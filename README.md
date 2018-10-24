# CSS Moon
An art project depicting the current phase of the moon in CSS

- [History & Purpose](#history)
- [Components](#components)
- [Specifics](#specifics)


## In Action
See the end product here: http://mitten.github.io/css-moon


## History & Purpose<a name="history"></a>
For many years, I have been wanting to create an image of the moon which would change dynamically with the phases of the actual moon. Finally, the technical tools exist to build it the way I want to.

My first attempts involved reading moon data from a weather API, and using javascript to rewrite CSS text colors and background colors to change from dark to light with the waxing and waning of the moon, without making any attempts at a moon shape. It was not very satifying, as it was too slow - grabbing the API data and then writing the CSS made page drawing times excrutiating.

Later attempts included trying to shift a moon shape from crescent to full and back, using then-new CSS tools like scale and transform. But again, the limitations of the API plus javascript method just made things too slow to be any fun, and at any kind of scale, I would have run out of free API calls. Plus, the CSS transformations were simply not well-supported across browsers.

Fast-forward to 2018. While attempting to set up a blog, I discovered Blot.im - a service which will make a website out of files on your Dropbox. You make posts by dropping text files into a folder, and Blot renders them with a Mustache-based template. The template can live on your Dropbox, too. 

And that was the piece of the moon puzzle that I needed! I can run a script to get the moon data on my local machine, which updates a CSS snippet in the Blot folder, which is then used for rendering the site immediately. As the moon is a slowly changing object, updating the data every 15 minutes is totally fine and keeps me under the free API call limit. And modern CSS transformations are now supported by just about every browser, so the moon shape change is totally doable as well.

I lament the fact that not many people watch the details of the physical world around us, and this project is my way of bringing some of that natural data to the digital world. The site gets darker as the moon wanes, and brighter as it waxes, giving visitors a subtle reminder that we exist on a spinning planet.


## Components<a name="components"></a>
The files in this repository are specific to the tools I've used to set up this dynamic system. However, you should be able to adapt them to a variety of platforms. Be clever.

**API**
You need a weather API which gives the age of the moon in days, and the illumination of the moon as a percent.

**Script**
You need to be able to manipulate the numbers you get from the API and write them to a file as CSS selectors. You also need to be able to automate the running of the script.

**Site Generator**
You need an automated way to update the CSS files for your site.


## Specifics<a name="specifics"></a>

