(*
This script writes a CSS fragment that is saved
to a template folder and is subsequently
included in a main CSS file. The script is run as
a launchd called local.moonupdate every 15 minutes,
effectively updating the background & text colors
and the shape of the moon image regularly
to match the illumination/phase of the moon.

You must put in your own client information for the API,
and update the path where the moon.css will be written.
*)

--get the illumination of the moon as a percentage and the age in days
tell application "JSON Helper"
	
	--change this to your zipcode, client ID, and secret key
	set theRecord to fetch JSON from "https://api.aerisapi.com/sunmoon/your-zipcode?client_id=your-client-id&client_secret=your-secret-key"
	
	set thePhase to phase of moon of item 1 of response of theRecord
	
	set moonage to age of thePhase as number
	
	set illumpercent to illum of thePhase as number
	
end tell

(*
- calculate the numbers to keep the text readable
- the addition of the inverse is to speed up the transition at the edges
- the color of the moonshadow is set here as well, so it matches the body background
- the text color for for the .light class is also set here (changes alpha value with HSLa)
*)

-- calculates body background, keeps a little color at the deep end
set illumbackground to 30 + (illumpercent * 0.7)

-- sets css text color appropriate to background
-- light text on dark background, dark text on midtone through light backgrounds
if illumbackground ≤ 55 then
	set illumtext to 70 + (illumpercent * 0.5) --light text
else
	set illumtext to (1 / illumpercent) + (illumpercent / 3) --dark text
end if

-- css for background and text color
-- change the first number of the hsl/hsla to get a different hue
set the_css to "body, .moonshadow {background:hsl(235,6%," & illumbackground & "%); color: hsl(0,0%," & illumtext & "%);} .light {color: hsla(0,0%," & illumtext & "%,.5);}" as string

-- adds a faint outline during the full moon, a fainter one just before and after, and two levels of faint glow otherwise
if moonage ≥ 14.5 and moonage ≤ 15.5 then
	set the_css to the_css & " .moonglow {box-shadow: 0px 0px 2px 0px inset hsla(0,0%," & illumtext & "%,.1);}" as string
else if (moonage ≥ 14 and moonage < 14.5) or (moonage > 15.5 and moonage ≤ 16) then
	set the_css to the_css & " .moonglow {box-shadow: 0px 0px 1px 0px inset hsla(0,0%," & illumtext & "%,.1);}" as string
else if (moonage ≥ 13 and moonage < 14) or (moonage > 16 and moonage ≤ 17) then
	set the_css to the_css & " .moonglow {box-shadow: 0px 2px 4px 0px rgba(255,255,255,.2);}" as string
else
	set the_css to the_css & " .moonglow {box-shadow: 0px 2px 4px 0px rgba(255,255,255,.1);}" as string
end if

(*
- four separate specifications are required
- two cases move a shadow across a white disc, two cases move a clipping path across a white disc
- the addition/subtraction of the inverses/multiples is to slow/speed up the transition at the edges
- the variance in numbers is due to trying to make things "look right" instead of being numerically accurate
- values for moonage are 0 to 29.53058868
*)

-- css for new moon to first quarter
if moonage ≤ 7.4 then
	if moonage = 7.4 then set moonage to 7.3999 --averts divide-by-zero error
	set scalemoonage to (0.27027 / (7.4 - moonage)) + 1 + (0.2 / (7.4 - moonage))
	if scalemoonage > 3 then set scalemoonage to 3
	set translatemoonage to 4 + (moonage * 6.21621) - (1 / moonage)
	set the_css to the_css & " .moonshadow {transform: scale(1," & scalemoonage & ") translate(-" & translatemoonage & "%, 0%);}" as string
end if

-- css for first quarter to full
if moonage > 7.4 and moonage ≤ 14.8 then
	set moonage to moonage - 7.4 --will never be zero, so no divide-by-zero error
	set radiusmoonage to -((moonage * 6.75675) - 120 + (45 - 3 * moonage))
	if radiusmoonage < 50 then set radiusmoonage to 50 --never go less than a circle
	set positionmoonage to -((moonage * 5.81081) - 93)
	if positionmoonage < 50 then set positionmoonage to 50 --never go farther than halfway
	set the_css to the_css & " .moonshadow {display: none;} .moon {-webkit-clip-path: ellipse(50% " & radiusmoonage & "% at " & positionmoonage & "% 50%); clip-path: ellipse(50% " & radiusmoonage & "% at " & positionmoonage & "% 50%);}" as string
end if

-- css for full to last quarter
if moonage > 14.8 and moonage ≤ 22.2 then
	set moonage to moonage - 14.8 --will never be zero, so no divide-by-zero error
	set radiusmoonage to (moonage * 6.75675) + 70 - (45 - 3 * moonage)
	if radiusmoonage < 50 then set radiusmoonage to 50 --never go less than a circle
	set positionmoonage to -((moonage * 5.81081) - 53)
	if positionmoonage > 50 then set positionmoonage to 50 --never go farther than halfway
	set the_css to the_css & " .moonshadow {display: none;} .moon {-webkit-clip-path: ellipse(50% " & radiusmoonage & "% at " & positionmoonage & "% 50%); clip-path: ellipse(50% " & radiusmoonage & "% at " & positionmoonage & "% 50%);}" as string
end if

-- css for last quarter to new
if moonage > 22.2 then
	set moonage to moonage - 22.2 --will never be zero, so no divide-by-zero error
	set scalemoonage to (0.27027 / moonage) + 1 + (0.2 / moonage)
	if scalemoonage > 3 then set scalemoonage to 3
	set translatemoonage to 46 - ((moonage * 6.21621) - (1 / moonage))
	set the_css to the_css & " .moonshadow {transform: scale(1," & scalemoonage & ") translate(" & translatemoonage & "%, 0%);}" as string
end if

-- choose css file --change this to your path
set cssFile to ("path:to:your:site:template:file:moon.css")

-- write everything to file
writeTextToFile(the_css, cssFile, true)

-- function to write info to file gracefully
on writeTextToFile(theText, theFile, overwriteExistingContent)
	try
		
		-- Convert the file to a string
		set theFile to theFile as string
		
		-- Open the file for writing
		set theOpenedFile to open for access file theFile with write permission
		
		-- Clear the file if content should be overwritten
		if overwriteExistingContent is true then set eof of theOpenedFile to 0
		
		-- Write the new content to the file
		write theText to theOpenedFile starting at eof
		
		-- Close the file
		close access theOpenedFile
		
		-- Return a boolean indicating that writing was successful
		return true
		
		-- Handle a write error
	on error
		
		-- Close the file
		try
			close access file theFile
		end try
		
		-- Return a boolean indicating that writing failed
		return false
	end try
end writeTextToFile
