TEXTMATE_FILE="TEXTMATE"
WAX_PATH = File.expand_path("wax")
WAX_PATH = File.expand_path("wax.framework/Resources") if not File.exists?(WAX_PATH)

desc "Create a Wax TextMate project"
task :tm => "TEXTMATE" do
  sh "mate #{TEXTMATE_FILE} ./scripts ./wax/lib/stdlib"
  sh "mate #{TEXTMATE_FILE}"
end

namespace :tm do
  desc "Install textmate lua & wax bundles"
  task :install_bundles do
    sh "mkdir -p ~/Library/Application\\ Support/TextMate/Bundles/"

    lua_bundle_dir = "~/Library/Application\\ Support/TextMate/Bundles/Lua.tmbundle"
    if not sh("test -e #{lua_bundle_dir}") {|ok, status| ok} # This is bad code...
      sh "curl -L http://github.com/textmate/lua.tmbundle/tarball/master | tar xvz"
      sh "mv textmate-lua.tmbundle* #{lua_bundle_dir}"
    end

    wax_bundle_dir = "~/Library/Application\\ Support/TextMate/Bundles/Wax.tmbundle"
    if not sh("test -e #{wax_bundle_dir}") {|ok, status| ok}
      sh "curl -L http://github.com/probablycorey/Wax.tmbundle/tarball/master | tar xvz"
      sh "mv probablycorey-[Ww]ax.tmbundle* #{wax_bundle_dir}"
    end
  end

  file TEXTMATE_FILE do |t|
    open(t.name, "w") do |file|
      file.write <<-TEXTMATE_HELP
Some tips to make life easier

1) Install the Lua and Wax TextMate Bundles.
  a) Either type "rake tm:install_bundles"

     Or, you can manually install the bundles from
     http://github.com/textmate/lua.tmbundle and
     http://github.com/probablycorey/Wax.tmbundle
     into ~/Library/Application\ Support/TextMate/Bundles

  b) From TextMate click Bundles > Bundle Editor > Reload Bundles

      TEXTMATE_HELP
    end
  end
end

desc "Update the wax lib with the lastest code"
task :update do
  puts
  puts "User Input Required!"
  puts "--------------------"
  print "About to remove wax directory '#{WAX_PATH}' and replace it with an updated version (y/n) "

  if STDIN.gets !~ /^y/i
    puts "Exiting... nothing was done!"
    return
  end

  tmp_dir = "./_wax-download"
  rm_rf tmp_dir
  mkdir_p tmp_dir
  sh "curl -L http://github.com/probablycorey/wax/tarball/master | tar -C #{tmp_dir} -x -z"
  rm_rf WAX_PATH
  sh "mv #{tmp_dir}/* \"#{WAX_PATH}\""
  rm_rf tmp_dir
end

desc "Git specific tasks"
namespace :git do

  desc "make the wax folder a submodule"
  task :sub do
    rm_rf WAX_PATH
    sh "git init"
    sh "git submodule add git@github.com:probablycorey/wax.git wax"
  end
end

desc "Build and run tests on the app"
task :test do
  sh "#{WAX_PATH}/bin/hammer --headless WAX_TEST=YES"
end

desc "Runs a REPL on the current app"
task :console do
  sh "#{WAX_PATH}/bin/hammer --headless WAX_REPL=YES"
end

desc "Build"
task :build do
  sh "#{WAX_PATH}/bin/hammer"
end

desc "Package an adhoc build"
task :adhoc do
  #sh "#{WAX_PATH}/bin/hammer clean"
  #rm_rf "build"

  output = `#{WAX_PATH}/bin/hammer -c 'Ad\\ Hoc' -v`
  success = ($? == 0)
  if not success
    puts output
  else
    puts output
    provisioning_id = output[/PROVISIONING_PROFILE\s+([\w\-]+)/, 1]
    provisioning_profile = `grep -rl '#{provisioning_id}' '#{ENV['HOME']}/Library/MobileDevice/Provisioning\ Profiles/'`.split("\n").first.strip
    puts provisioning_id

    raise "Could not find the Ad Hoc provisioning profile matching #{provisioning_id}" if not provisioning_profile or not provisioning_id

    app_file = output[/CODESIGNING_FOLDER_PATH\s+(.*?)$/, 1]
    executable_name = output[/EXECUTABLE_NAME\s+(.*?)$/, 1]
    output_dir = "archive"
    rm_rf output_dir
    mkdir output_dir

    sh "zip -r #{output_dir}/#{executable_name}.ipa '#{provisioning_profile}' #{app_file}"
    sh "open #{output_dir}"
  end
end

desc "Package a distribution build"
task :distribution do
  if not ENV["sdk"]
    raise "\nYou need to specify an sdk!\nUsage: rake adhoc sdk=iphoneos3.0\n"
  end

  sh "#{WAX_PATH}/bin/hammer clean"
  rm_rf "build"

  output = `#{WAX_PATH}/bin/hammer --sdk #{ENV["sdk"]} -c 'Distribution' -v`
  success = ($? == 0)
  if not success
    puts output
  else
    timestamp = Time.now.strftime("%m-%d-%y")
    dir = "distribution-builds/#{timestamp}"
    rm_rf dir
    mkdir_p dir

    app_file = Dir["build/Distribution-iphoneos/*.app"]

    sh "mv '#{app_file}' '#{dir}'"
    sh "cd '#{dir}'; zip -r distribution.zip ./*"
    sh "open #{dir}"
  end
end

desc "Build and run the app"
task :run do
  sh "#{WAX_PATH}/bin/hammer --run"
end

desc "Goes through your lua scripts and updates all the xibs to know about waxClasses"
task :ib do
  sh "#{WAX_PATH}/bin/update-xibs"
end
