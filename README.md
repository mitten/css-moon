# CSS Moon
An art project depicting the current phase of the moon in CSS

- [History & Purpose](#history--purpose)
- [Components](#components)
- [Specifics](#specifics)
	- [API](#API)
	- [Script](#script)
	- [Site Generator](#site-generator)
- [Final Thoughts](#final-thoughts)


## In Action
See the end product here: http://mitten.github.io/css-moon


## History & Purpose
For many years, I have been wanting to create an image of the moon which would change dynamically with the phases of the actual moon. Finally, the technical tools exist to build it the way I want to.

My first attempts involved reading moon data from a weather API, and using javascript to rewrite CSS text colors and background colors to change from dark to light with the waxing and waning of the moon, without making any attempts at a moon shape. It was not very satifying, as it was too slow - grabbing the API data and then writing the CSS made page drawing times excrutiating.

Later attempts included trying to shift a moon shape from crescent to full and back, using then-new CSS tools like scale and transform. But again, the limitations of the API plus javascript method just made things too slow to be any fun, and at any kind of scale, I would have run out of free API calls. Plus, the CSS transformations were simply not well-supported across browsers.

Fast-forward to 2018. While attempting to set up a blog, I discovered Blot.im - a service which will make a website out of files on your Dropbox. You make posts by dropping text files into a folder, and Blot renders them with a Mustache-based template. The template can live on your Dropbox, too. 

And that was the piece of the moon puzzle that I needed! I can run a script to get the moon data on my local machine, which updates a CSS snippet in the Blot folder, which is then used for rendering the site immediately. As the moon is a slowly changing object, updating the data every 15 minutes is totally fine and keeps me under the free API call limit. And modern CSS transformations are now supported by just about every browser, so the moon shape change is totally doable as well.

I lament the fact that not many people watch the details of the physical world around us, and this project is my way of bringing some of that natural data to the digital world. The site gets darker as the moon wanes, and brighter as it waxes, giving visitors a subtle reminder that we exist on a spinning planet.


## Components
The files in this repository are specific to the tools I've used to set up this dynamic system. However, you should be able to adapt them to a variety of platforms. Be clever.

**API**
You need a weather API which gives the age of the moon in days, and the illumination of the moon as a percent.

**Script**
You need to be able to manipulate the numbers you get from the API and write them to a file as CSS selectors. You also need to be able to automate the running of the script.

**Site Generator**
You need an automated way to update the CSS files for your site.


## Specifics

### API
I am using the [Aeris Weather API](https://www.aerisweather.com/). The two data items you need are age of moon in days and illumination of moon as a percentage.

### Script
The script (get-moon-data.scpt) grabs the data, performs various calculations to create CSS selectors, and writes those to a file. In order to read API data with Applescript, you'll need to install the free helper app [JSON Helper](http://www.mousedown.net/mouseware/JSONHelper.html).

Read the comments in the script for more information about how the various numbers are calculated. Be sure to put in your own API client ID and secret key, and to change the path to the CSS file.

In order to automate the running of the script, I created a launchd file (local.moonupdate.plist) which runs every 15 minutes. Be sure to change the path to your path. [Quick launchd tutorial](https://www.maketecheasier.com/use-launchd-run-scripts-on-schedule-macos/) 

The moon.css fragment is pulled into the main styles.css file via @import.


### Site Generator
I am using [Blot.im](http://blot.im). It automatically updates the CSS fragment in the blog template folder any time the file is updated, which is the crux of this whole system.


## Final Thoughts
I'm an artist, not a coder, and I wrote this with the tools I know. I am sure there are many, many other ways to do this, and I provided the details here so that you can rewrite it with the tools you know. Enjoy.

## License
<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.

You may use this code without warranty for non-commercial projects. For commercial projects, please contact me at https://laurafisher.art for a license. 

