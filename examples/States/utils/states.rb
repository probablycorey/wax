require 'rubygems'
require 'plist'

states = []

for state_data in DATA.read.scan(/<tr>(.*?)<\/tr>/im)
#  state_data = *state_data
  state_data = state_data.first.split("</td>")
  
  states << state = {}
  state[:name] = state_data[0][/>([^<]+)<\/a/, 1]
  state[:statehood] = state_data[1][/>([^<]+)$/, 1].to_i
  state[:capital] = state_data[2][/>([^<]+)<\/a/, 1]
  state[:capitalhood] = state_data[3][/>([^<]+)$/, 1].to_i
  state[:population] = state_data[5][/>([^<]+)$/, 1]  
end

states.save_plist("../data/states.plist")

__END__
<tr>
<td><a href="/wiki/Alabama" title="Alabama">Alabama</a></td>
<td align="center">1818</td>
<td><a href="/wiki/Montgomery,_Alabama" title="Montgomery, Alabama">Montgomery</a></td>
<td align="center">1846</td>
<td align="center">No</td>
<td align="right">200,127</td>
<td align="right">469,268</td>

<td><a href="/wiki/Birmingham,_Alabama" title="Birmingham, Alabama">Birmingham</a> is the state's largest city.</td>
</tr>
<tr>
<td><a href="/wiki/Alaska" title="Alaska">Alaska</a></td>
<td align="center">1959</td>
<td><a href="/wiki/Juneau,_Alaska" title="Juneau, Alaska">Juneau</a></td>
<td align="center">1906</td>
<td align="center">No</td>
<td align="right">30,987</td>

<td align="right"></td>
<td><a href="/wiki/Anchorage,_Alaska" title="Anchorage, Alaska">Anchorage</a> is the state's largest city. Only state capital to border another country.</td>
</tr>
<tr>
<td><a href="/wiki/Arizona" title="Arizona">Arizona</a></td>
<td align="center">1912</td>
<td><a href="/wiki/Phoenix,_Arizona" title="Phoenix, Arizona">Phoenix</a></td>
<td align="center">1889</td>
<td align="center">Yes</td>

<td align="right">1,512,986</td>
<td align="right">4,039,182</td>
<td>Phoenix is the most populous U.S. state capital.</td>
</tr>
<tr>
<td><a href="/wiki/Arkansas" title="Arkansas">Arkansas</a></td>
<td align="center">1836</td>
<td><a href="/wiki/Little_Rock,_Arkansas" title="Little Rock, Arkansas">Little Rock</a></td>
<td align="center">1821</td>
<td align="center">Yes</td>

<td align="right">204,370</td>
<td align="right">652,834</td>
</tr>
<tr>
<td><a href="/wiki/California" title="California">California</a></td>
<td align="center">1850</td>
<td><a href="/wiki/Sacramento,_California" title="Sacramento, California">Sacramento</a></td>
<td align="center">1854</td>
<td align="center">No</td>
<td align="right">467,343</td>

<td align="right">2,136,604</td>
<td>The <a href="/wiki/Supreme_Court_of_California" title="Supreme Court of California">Supreme Court of California</a> sits in <a href="/wiki/San_Francisco" title="San Francisco">San Francisco</a>. <a href="/wiki/Los_Angeles" title="Los Angeles">Los Angeles</a> is the state's largest city.</td>
</tr>
<tr>
<td><a href="/wiki/Colorado" title="Colorado">Colorado</a></td>
<td align="center">1876</td>

<td><a href="/wiki/Denver" title="Denver">Denver</a></td>
<td align="center">1867</td>
<td align="center">Yes</td>
<td align="right">566,974</td>
<td align="right">2,408,750</td>
<td></td>
</tr>
<tr>
<td><a href="/wiki/Connecticut" title="Connecticut">Connecticut</a></td>
<td align="center">1788</td>

<td><a href="/wiki/Hartford,_Connecticut" title="Hartford, Connecticut">Hartford</a></td>
<td align="center">1875</td>
<td align="center">No</td>
<td align="right">124,397</td>
<td align="right">1,188,241</td>
<td><a href="/wiki/Bridgeport,_Connecticut" title="Bridgeport, Connecticut">Bridgeport</a> is the state's largest city, but <a href="/wiki/Greater_Hartford" title="Greater Hartford">Greater Hartford</a> is the largest metro area.</td>

</tr>
<tr>
<td><a href="/wiki/Delaware" title="Delaware">Delaware</a></td>
<td align="center">1787</td>
<td><a href="/wiki/Dover,_Delaware" title="Dover, Delaware">Dover</a></td>
<td align="center">1777</td>
<td align="center">No</td>
<td align="right">32,135</td>
<td align="right"></td>
<td><a href="/wiki/Wilmington,_Delaware" title="Wilmington, Delaware">Wilmington</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Florida" title="Florida">Florida</a></td>
<td align="center">1845</td>
<td><a href="/wiki/Tallahassee,_Florida" title="Tallahassee, Florida">Tallahassee</a></td>
<td align="center">1824</td>
<td align="center">No</td>
<td align="right">168,979</td>
<td align="right">336,501</td>
<td><a href="/wiki/Jacksonville,_Florida" title="Jacksonville, Florida">Jacksonville</a> is the largest city, and <a href="/wiki/South_Florida_metropolitan_area" title="South Florida metropolitan area">Miami</a> has the largest metro area.</td>

</tr>
<tr>
<td><a href="/wiki/Georgia_(U.S._state)" title="Georgia (U.S. state)">Georgia</a></td>
<td align="center">1788</td>
<td><a href="/wiki/Atlanta" title="Atlanta">Atlanta</a></td>
<td align="center">1868</td>
<td align="center">Yes</td>
<td align="right">486,411</td>
<td align="right">5,138,223</td>
<td>Atlanta is the most populous state capital by metropolitan area.</td>

</tr>
<tr>
<td><a href="/wiki/Hawaii" title="Hawaii">Hawaii</a></td>
<td align="center">1959</td>
<td><a href="/wiki/Honolulu" title="Honolulu">Honolulu</a></td>
<td align="center">1845</td>
<td align="center">Yes</td>
<td align="right">377,357</td>
<td align="right">909,863</td>
<td></td>

</tr>
<tr>
<td><a href="/wiki/Idaho" title="Idaho">Idaho</a></td>
<td align="center">1890</td>
<td><a href="/wiki/Boise,_Idaho" title="Boise, Idaho">Boise</a></td>
<td align="center">1865</td>
<td align="center">Yes</td>
<td align="right">201,287</td>
<td align="right">635,450</td>
<td></td>

</tr>
<tr>
<td><a href="/wiki/Illinois" title="Illinois">Illinois</a></td>
<td align="center">1818</td>
<td><a href="/wiki/Springfield,_Illinois" title="Springfield, Illinois">Springfield</a></td>
<td align="center">1837</td>
<td align="center">No</td>
<td align="right">116,482</td>
<td align="right">188,951</td>
<td><a href="/wiki/Chicago" title="Chicago">Chicago</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Indiana" title="Indiana">Indiana</a></td>
<td align="center">1816</td>
<td><a href="/wiki/Indianapolis" title="Indianapolis">Indianapolis</a></td>
<td align="center">1825</td>
<td align="center">Yes</td>
<td align="right">791,926</td>
<td align="right">1,984,664</td>
<td></td>

</tr>
<tr>
<td><a href="/wiki/Iowa" title="Iowa">Iowa</a></td>
<td align="center">1846</td>
<td><a href="/wiki/Des_Moines,_Iowa" title="Des Moines, Iowa">Des Moines</a></td>
<td align="center">1857</td>
<td align="center">Yes</td>
<td align="right">209,124</td>
<td align="right">625,384</td>
<td></td>

</tr>
<tr>
<td><a href="/wiki/Kansas" title="Kansas">Kansas</a></td>
<td align="center">1861</td>
<td><a href="/wiki/Topeka,_Kansas" title="Topeka, Kansas">Topeka</a></td>
<td align="center">1856</td>
<td align="center">No</td>
<td align="right">122,327</td>
<td align="right">228,894</td>
<td><a href="/wiki/Wichita,_Kansas" title="Wichita, Kansas">Wichita</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Kentucky" title="Kentucky">Kentucky</a></td>
<td align="center">1792</td>
<td><a href="/wiki/Frankfort,_Kentucky" title="Frankfort, Kentucky">Frankfort</a></td>
<td align="center">1792</td>
<td align="center">No</td>
<td align="right">27,741</td>
<td align="right">69,670</td>
<td><a href="/wiki/Louisville,_Kentucky" title="Louisville, Kentucky">Louisville</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Louisiana" title="Louisiana">Louisiana</a></td>
<td align="center">1812</td>
<td><a href="/wiki/Baton_Rouge,_Louisiana" title="Baton Rouge, Louisiana">Baton Rouge</a></td>
<td align="center">1880</td>
<td align="center">No</td>
<td align="right">224,097</td>
<td align="right">751,965</td>
<td><a href="/wiki/New_Orleans" title="New Orleans">New Orleans</a> is the state's largest city and home to the Louisiana Supreme Court.</td>

</tr>
<tr>
<td><a href="/wiki/Maine" title="Maine">Maine</a></td>
<td align="center">1820</td>
<td><a href="/wiki/Augusta,_Maine" title="Augusta, Maine">Augusta</a></td>
<td align="center">1832</td>
<td align="center">No</td>
<td align="right">18,560</td>
<td align="right">117,114</td>
<td>Augusta was officially made the capital 1827, but the legislature did not sit there until 1832. <a href="/wiki/Portland,_Maine" title="Portland, Maine">Portland</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Maryland" title="Maryland">Maryland</a></td>
<td align="center">1788</td>
<td><a href="/wiki/Annapolis,_Maryland" title="Annapolis, Maryland">Annapolis</a></td>
<td align="center">1694</td>
<td align="center">No</td>
<td align="right">36,217</td>
<td align="right"></td>
<td>Annapolis is the third-longest serving capital in the United States after Santa Fe and Boston. Its capital building is the oldest still in use. <a href="/wiki/Baltimore" title="Baltimore">Baltimore</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Massachusetts" title="Massachusetts">Massachusetts</a></td>
<td align="center">1788</td>
<td><a href="/wiki/Boston" title="Boston">Boston</a></td>
<td align="center">1630</td>
<td align="center">Yes</td>
<td align="right">590,763</td>
<td align="right">4,455,217</td>
<td>Boston is the longest continuously serving capital in the United States. The <a href="/wiki/Greater_Boston" title="Greater Boston">Boston-Worcester-Manchester Combined Statistical Area</a> encompasses the state capitals of <a href="/wiki/Massachusetts" title="Massachusetts">Massachusetts</a>, <a href="/wiki/New_Hampshire" title="New Hampshire">New Hampshire</a>, and <a href="/wiki/Rhode_Island" title="Rhode Island">Rhode Island</a>.</td>

</tr>
<tr>
<td><a href="/wiki/Michigan" title="Michigan">Michigan</a></td>
<td align="center">1837</td>
<td><a href="/wiki/Lansing,_Michigan" title="Lansing, Michigan">Lansing</a></td>
<td align="center">1847</td>
<td align="center">No</td>
<td align="right">119,128</td>
<td align="right">454,044</td>
<td>Lansing is the only state capital that is not also the <a href="/wiki/County_seat" title="County seat">county seat</a> of the county in which it is situated. <a href="/wiki/Detroit" title="Detroit">Detroit</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Minnesota" title="Minnesota">Minnesota</a></td>
<td align="center">1858</td>
<td><a href="/wiki/Saint_Paul,_Minnesota" title="Saint Paul, Minnesota">Saint Paul</a></td>
<td align="center">1849</td>
<td align="center">No</td>
<td align="right">287,151</td>
<td align="right">3,502,891</td>
<td><a href="/wiki/Minneapolis" title="Minneapolis">Minneapolis</a> is the state's largest city; it and Saint Paul form the core of <a href="/wiki/Minneapolis_%E2%80%93_Saint_Paul" title="Minneapolis – Saint Paul">the state's largest metropolitan area</a>.</td>

</tr>
<tr>
<td><a href="/wiki/Mississippi" title="Mississippi">Mississippi</a></td>
<td align="center">1817</td>
<td><a href="/wiki/Jackson,_Mississippi" title="Jackson, Mississippi">Jackson</a></td>
<td align="center">1821</td>
<td align="center">Yes</td>
<td align="right">184,256</td>
<td align="right">529,456</td>
<td></td>

</tr>
<tr>
<td><a href="/wiki/Missouri" title="Missouri">Missouri</a></td>
<td align="center">1821</td>
<td><a href="/wiki/Jefferson_City,_Missouri" title="Jefferson City, Missouri">Jefferson City</a></td>
<td align="center">1826</td>
<td align="center">No</td>
<td align="right">39,636</td>
<td align="right">146,363</td>
<td><a href="/wiki/Kansas_City,_Missouri" title="Kansas City, Missouri">Kansas City</a> is the state's largest city, and <a href="/wiki/Greater_St._Louis" title="Greater St. Louis">Greater St. Louis</a> is the state's largest metropolitan area.</td>

</tr>
<tr>
<td><a href="/wiki/Montana" title="Montana">Montana</a></td>
<td align="center">1889</td>
<td><a href="/wiki/Helena,_Montana" title="Helena, Montana">Helena</a></td>
<td align="center">1875</td>
<td align="center">No</td>
<td align="right">25,780</td>
<td align="right">67,636</td>
<td><a href="/wiki/Billings,_Montana" title="Billings, Montana">Billings</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Nebraska" title="Nebraska">Nebraska</a></td>
<td align="center">1867</td>
<td><a href="/wiki/Lincoln,_Nebraska" title="Lincoln, Nebraska">Lincoln</a></td>
<td align="center">1867</td>
<td align="center">No</td>
<td align="right">225,581</td>
<td align="right">283,970</td>
<td><a href="/wiki/Omaha,_Nebraska" title="Omaha, Nebraska">Omaha</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Nevada" title="Nevada">Nevada</a></td>
<td align="center">1864</td>
<td><a href="/wiki/Carson_City,_Nevada" title="Carson City, Nevada">Carson City</a></td>
<td align="center">1861</td>
<td align="center">No</td>
<td align="right">57,701</td>
<td align="right"></td>
<td><a href="/wiki/Las_Vegas,_Nevada" title="Las Vegas, Nevada">Las Vegas</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/New_Hampshire" title="New Hampshire">New Hampshire</a></td>
<td align="center">1788</td>
<td><a href="/wiki/Concord,_New_Hampshire" title="Concord, New Hampshire">Concord</a></td>
<td align="center">1808</td>
<td align="center">No</td>
<td align="right">42,221</td>
<td align="right"></td>
<td><a href="/wiki/Manchester,_New_Hampshire" title="Manchester, New Hampshire">Manchester</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/New_Jersey" title="New Jersey">New Jersey</a></td>
<td align="center">1787</td>
<td><a href="/wiki/Trenton,_New_Jersey" title="Trenton, New Jersey">Trenton</a></td>
<td align="center">1784</td>
<td align="center">No</td>
<td align="right">84,639</td>
<td align="right">367,605</td>
<td><a href="/wiki/Newark,_New_Jersey" title="Newark, New Jersey">Newark</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/New_Mexico" title="New Mexico">New Mexico</a></td>
<td align="center">1912</td>
<td><a href="/wiki/Santa_Fe,_New_Mexico" title="Santa Fe, New Mexico">Santa Fe</a></td>
<td align="center">1610</td>
<td align="center">No</td>
<td align="right">70,631</td>
<td align="right">142,407</td>
<td>Santa Fe is the longest serving capital in the United States. <a href="/wiki/Ciudad_Ju%C3%A1rez#History" title="Ciudad Juárez">El Paso del Norte</a> served as the capital of the <a href="/wiki/Santa_F%C3%A9_de_Nuevo_M%C3%A9jico" title="Santa Fé de Nuevo Méjico" class="mw-redirect">Santa Fé de Nuevo Méjico</a> colony-in-exile during the <a href="/wiki/Pueblo_Revolt" title="Pueblo Revolt">Pueblo Revolt</a> of 1680-1692. <a href="/wiki/Albuquerque,_New_Mexico" title="Albuquerque, New Mexico">Albuquerque</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/New_York" title="New York">New York</a></td>
<td align="center">1788</td>
<td><a href="/wiki/Albany,_New_York" title="Albany, New York">Albany</a></td>
<td align="center">1797</td>
<td align="center">No</td>
<td align="right">95,993</td>
<td align="right">1,147,850</td>
<td><a href="/wiki/New_York_City" title="New York City">New York City</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/North_Carolina" title="North Carolina">North Carolina</a></td>
<td align="center">1789</td>
<td><a href="/wiki/Raleigh,_North_Carolina" title="Raleigh, North Carolina">Raleigh</a></td>
<td align="center">1794</td>
<td align="center">No</td>
<td align="right">380,173</td>
<td align="right">1,635,974</td>
<td><a href="/wiki/Charlotte,_North_Carolina" title="Charlotte, North Carolina">Charlotte</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/North_Dakota" title="North Dakota">North Dakota</a></td>
<td align="center">1889</td>
<td><a href="/wiki/Bismarck,_North_Dakota" title="Bismarck, North Dakota">Bismarck</a></td>
<td align="center">1883</td>
<td align="center">No</td>
<td align="right">55,533</td>
<td align="right">101,138</td>
<td><a href="/wiki/Fargo,_North_Dakota" title="Fargo, North Dakota">Fargo</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Ohio" title="Ohio">Ohio</a></td>
<td align="center">1803</td>
<td><a href="/wiki/Columbus,_Ohio" title="Columbus, Ohio">Columbus</a></td>
<td align="center">1816</td>
<td align="center">Yes</td>
<td align="right">733,203</td>
<td align="right">1,725,570</td>
<td>The <a href="/wiki/Greater_Cleveland" title="Greater Cleveland">Cleveland</a> and <a href="/wiki/Cincinnati-Northern_Kentucky_metropolitan_area" title="Cincinnati-Northern Kentucky metropolitan area">Cincinnati</a> metropolitan areas are both larger.</td>

</tr>
<tr>
<td><a href="/wiki/Oklahoma" title="Oklahoma">Oklahoma</a></td>
<td align="center">1907</td>
<td nowrap="nowrap"><a href="/wiki/Oklahoma_City" title="Oklahoma City">Oklahoma City</a></td>
<td align="center">1910</td>
<td align="center">Yes</td>
<td align="right">541,500</td>
<td align="right">1,266,445</td>
<td>Oklahoma City is the shortest serving current state capital in the United States.</td>

</tr>
<tr>
<td><a href="/wiki/Oregon" title="Oregon">Oregon</a></td>
<td align="center">1859</td>
<td><a href="/wiki/Salem,_Oregon" title="Salem, Oregon">Salem</a></td>
<td align="center">1855</td>
<td align="center">No</td>
<td align="right">149,305</td>
<td align="right">539,203</td>
<td><a href="/wiki/Portland,_Oregon" title="Portland, Oregon">Portland</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Pennsylvania" title="Pennsylvania">Pennsylvania</a></td>
<td align="center">1787</td>
<td><a href="/wiki/Harrisburg,_Pennsylvania" title="Harrisburg, Pennsylvania">Harrisburg</a></td>
<td align="center">1812</td>
<td align="center">No</td>
<td align="right">48,950</td>
<td align="right">384,600</td>
<td><a href="/wiki/Philadelphia" title="Philadelphia">Philadelphia</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Rhode_Island" title="Rhode Island">Rhode Island</a></td>
<td align="center">1790</td>
<td><a href="/wiki/Providence,_Rhode_Island" title="Providence, Rhode Island">Providence</a></td>
<td align="center">1900</td>
<td align="center">Yes</td>
<td align="right">176,862</td>
<td align="right">1,612,989</td>
<td>Providence also served as the capital 1636-1686 and 1689-1776. It was one of five co-capitals 1776-1853, and one of two co-capitals 1853-1900.</td>

</tr>
<tr>
<td><a href="/wiki/South_Carolina" title="South Carolina">South Carolina</a></td>
<td align="center">1788</td>
<td><a href="/wiki/Columbia,_South_Carolina" title="Columbia, South Carolina">Columbia</a></td>
<td align="center">1786</td>
<td align="center">Yes</td>
<td align="right">122,819</td>
<td align="right">703,771</td>
<td></td>

</tr>
<tr>
<td><a href="/wiki/South_Dakota" title="South Dakota">South Dakota</a></td>
<td align="center">1889</td>
<td><a href="/wiki/Pierre,_South_Dakota" title="Pierre, South Dakota">Pierre</a></td>
<td align="center">1889</td>
<td align="center">No</td>
<td align="right">13,876</td>
<td align="right"></td>
<td><a href="/wiki/Sioux_Falls,_South_Dakota" title="Sioux Falls, South Dakota">Sioux Falls</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Tennessee" title="Tennessee">Tennessee</a></td>
<td align="center">1796</td>
<td><a href="/wiki/Nashville,_Tennessee" title="Nashville, Tennessee">Nashville</a></td>
<td align="center">1826</td>
<td align="center">No</td>
<td align="right">607,413</td>
<td align="right">1,455,097</td>
<td><a href="/wiki/Memphis,_Tennessee" title="Memphis, Tennessee">Memphis</a> is the state's largest city, and <a href="/wiki/Nashville_Metropolitan_Statistical_Area" title="Nashville Metropolitan Statistical Area">Nashville</a> is the largest metro area.</td>

</tr>
<tr>
<td><a href="/wiki/Texas" title="Texas">Texas</a></td>
<td align="center">1845</td>
<td><a href="/wiki/Austin,_Texas" title="Austin, Texas">Austin</a></td>
<td align="center">1839</td>
<td align="center">No</td>
<td align="right">709,893</td>
<td align="right">1,513,565</td>
<td><a href="/wiki/Houston" title="Houston">Houston</a> is the state's largest city, and <a href="/wiki/Dallas%E2%80%93Fort_Worth_Metroplex" title="Dallas–Fort Worth Metroplex">Dallas–Fort Worth</a> is the largest metro area. It is the largest state capital that is not also state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Utah" title="Utah">Utah</a></td>
<td align="center">1896</td>
<td nowrap="nowrap"><a href="/wiki/Salt_Lake_City" title="Salt Lake City">Salt Lake City</a></td>
<td align="center">1858</td>
<td align="center">Yes</td>
<td align="right">181,743</td>
<td align="right">1,067,722</td>
<td></td>

</tr>
<tr>
<td><a href="/wiki/Vermont" title="Vermont">Vermont</a></td>
<td align="center">1791</td>
<td><a href="/wiki/Montpelier,_Vermont" title="Montpelier, Vermont">Montpelier</a></td>
<td align="center">1805</td>
<td align="center">No</td>
<td align="right">8,035</td>
<td align="right"></td>
<td>Montpelier is the least populous U.S. state capital. <a href="/wiki/Burlington,_Vermont" title="Burlington, Vermont">Burlington</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Virginia" title="Virginia">Virginia</a></td>
<td align="center">1788</td>
<td><a href="/wiki/Richmond,_Virginia" title="Richmond, Virginia">Richmond</a></td>
<td align="center">1780</td>
<td align="center">No</td>
<td align="right">195,251</td>
<td align="right">1,194,008</td>
<td><a href="/wiki/Virginia_Beach,_Virginia" title="Virginia Beach, Virginia" class="mw-redirect">Virginia Beach</a> is the state's largest city, and <a href="/wiki/Northern_Virginia" title="Northern Virginia">Northern Virginia</a> is the state's largest metro area.</td>

</tr>
<tr>
<td><a href="/wiki/Washington" title="Washington">Washington</a></td>
<td align="center">1889</td>
<td><a href="/wiki/Olympia,_Washington" title="Olympia, Washington">Olympia</a></td>
<td align="center">1853</td>
<td align="center">No</td>
<td align="right">42,514</td>
<td align="right">234,670</td>
<td><a href="/wiki/Seattle" title="Seattle">Seattle</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/West_Virginia" title="West Virginia">West Virginia</a></td>
<td align="center">1863</td>
<td><a href="/wiki/Charleston,_West_Virginia" title="Charleston, West Virginia">Charleston</a></td>
<td align="center">1885</td>
<td align="center">Yes</td>
<td align="right">52,700</td>
<td align="right">305,526</td>
<td></td>

</tr>
<tr>
<td><a href="/wiki/Wisconsin" title="Wisconsin">Wisconsin</a></td>
<td align="center">1848</td>
<td><a href="/wiki/Madison,_Wisconsin" title="Madison, Wisconsin">Madison</a></td>
<td align="center">1838</td>
<td align="center">No</td>
<td align="right">221,551</td>
<td align="right">543,022</td>
<td><a href="/wiki/Milwaukee" title="Milwaukee">Milwaukee</a> is the state's largest city.</td>

</tr>
<tr>
<td><a href="/wiki/Wyoming" title="Wyoming">Wyoming</a></td>
<td align="center">1890</td>
<td><a href="/wiki/Cheyenne,_Wyoming" title="Cheyenne, Wyoming">Cheyenne</a></td>
<td align="center">1869</td>
<td align="center">Yes</td>
<td align="right">55,362</td>
<td align="right">85,384</td>
<td></td>

</tr>
