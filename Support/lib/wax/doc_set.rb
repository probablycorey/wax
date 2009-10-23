# Stolen from the obj-c textmate bundle

SUPPORT = ENV['TM_SUPPORT_PATH']

require SUPPORT + '/lib/exit_codes'
require SUPPORT + '/lib/escape'
require SUPPORT + '/lib/osx/plist'
require SUPPORT + '/lib/ui'

module Wax
  class DocSet
    CMD = "/Developer/usr/bin/docsetutil search -skip-text -query "
    PATH = Dir.glob("/Developer/Platforms/iPhoneOS.platform/Developer/Documentation/DocSets/*.docset").last


#    {5=>"instm",     11=>"data",     6=>"macro",     12=>"intf",     1=>"intfm",     7=>"instp",     13=>"cat",     2=>"econst",     8=>"clm",     14=>"intfp",     3=>"func",     9=>"cl",     4=>"tdef",     10=>"tag"}
    CLASS = 'cl'
    PROTOCOL = 'intf'
    PROTOCOL_PROPERTY = 'intfp'
    CATEGORY = 'cat'
    METHOD = 'instm'
    CLASS_METHOD = 'clm'
    PROTOCOL_METHOD = 'intfm'
    ENUM = 'econst'
    TYPEDEF = 'tdef'
    MACRO = 'macro'
    DATA = 'data'
    FUNCTION = 'func'

    TYPE_IDS = {CLASS => 'Class', PROTOCOL_PROPERTY => 'Protocol Property', CATEGORY => 'Category', 
                METHOD => 'Method', PROTOCOL_METHOD => 'Protocol Method', ENUM => 'Enum', 
                TYPEDEF => 'Typedef', MACRO => 'Macro', DATA => 'Data', 
                FUNCTION => 'Function'}


    Man = Struct.new(:url, :language, :klass)
    class Man
      def title
        klass
      end
    end

    Ref = Struct.new(:docset, :language, :type, :klass, :thing, :path)
    class Ref
      def url
        path[0] == ?/ ? path : docset + "/Contents/Resources/Documents/" + path
      end

      # A '-' as a title in the popup menu not very useful so use the type field instead.
      def title
        klass == '-' ? TYPE_IDS[type] || type  : klass
      end
  
      # Test if we are referring to documentation about the same
      # thing, but from different docsets. (used by uniq).
      def eql?(other)
        language == other.language && type == other.type && 
          klass == other.klass && thing == other.thing
      end
  
      # Also needed by uniq
      def hash
        (language + type + klass + thing).hash
      end
    end


    # Split the query result into its component types and document path.
    # language is 'Objective-C', 'C', 'C++'
    # type is 'instm' (instance method), 'clsm' (class method), 'func' , 'econst', 'tag', 'tdef' and so on.
    # klass holds the class or '-' if no class is appropriate (for a C function, for example).
    # thing is the method, function, constant, etc.
    def self.parts_of_reference(docset, ref_str)
      ref = ref_str.split
      if ref.length != 2
        TextMate.exit_show_tool_tip "Cannot parse reference: '#{ref_str}'"
      end

      language, type, klass, thing = ref[0].split('/')
      Ref.new(docset, language, type, klass, thing, ref[1])
    end
  
    def self.search(query, *type_filters)
      results = []
      TextMate.exit_show_tool_tip "Could not find iPhone OS docset: #{PATH}" unless File.exists? PATH
      TextMate.exit_show_tool_tip "No search query given for docset" unless query and not query.empty?      
  
      cmd = CMD + " '" + query + "' " + PATH
      response = `#{cmd}`

      case response # elaborate for doc purposes
        when ''
          # Not found.
        when /Documentation set path does not exist/
          # Docset not installed or moved somewhere else.
        else
          response.split("\n").each {|r| results << parts_of_reference(PATH, r)}
      end  
  
      # Remove any duplicated documentation (from different docsets).
      results.reject! { |result| not type_filters.include?(result.type) } unless type_filters.empty?
  
      return results
    end

    def self.show_document(results)
      if results.nil? || results.empty?
        return nil
      elsif results.length == 1
        url = results[0].url
      else
        # Ask the user which class they are interested in.
        url = get_user_selected_reference(results)
      end
  
      if url
        TextMate.exit_show_html "<meta http-equiv='Refresh' content='0;URL=tm-file://#{url}'>"
      else
        TextMate.exit_discard  
      end
    end

    def self.man_page(query)
      if `man 2>&1 -S2:3 -w #{query}` !~ /No manual entry/
        page = `#{e_sh SUPPORT}/bin/html_man.sh -S2:3 #{query}`
        Man.new(page, 'C', 'man(2, 3)')
      else
        nil
      end
    end

    def self.get_user_selected_reference(refs)
      refs.sort! {|a, b| a.thing <=> b.thing}
      
      choices = refs.map do |ref|
        description = "#{ref.klass} #{TYPE_IDS[ref.type]}"
        {'title' => "#{ref.thing} (#{description})", 'url' => ref.url}
      end
      
      plist = {'menuItems' => choices}.to_plist
      
      res = OSX::PropertyList::load(%x{"$DIALOG" -up #{e_sh plist} })  
      res['selectedMenuItem'] ? res['selectedMenuItem']['url'] : nil
    end
  end
  
  # TESTS
  # -----
  if $0 == __FILE__

  require 'rubygems'
  require 'test/unit'
  require 'shoulda'

  class QueryTest < Test::Unit::TestCase
    context "A search query" do
      should "returns a match" do
        assert_equal 1, DocSet.search("UITableView").size
        assert_equal "UITableView", DocSet.search("UITableView").first.thing
      end
  
      should "return multiple partial matches" do
        assert_operator 1, :<, DocSet.search("UITable*").size
      end

      should "filter based on type" do
        for result in DocSet.search("UITable*", DocSet::CLASS)
          assert_equal DocSet::CLASS, result.type
        end
      end
  
      should "filter based on multiple types" do
        for result in DocSet.search("UITable*", DocSet::CLASS, DocSet::METHOD)
          assert_contains [DocSet::CLASS, DocSet::METHOD], result.type
        end
      end    
    end
  end

  end
end