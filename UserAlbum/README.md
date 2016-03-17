# Notes

This is my solution for your exercise.

* It downloads the data for each step (Users, Albums, Photos) for each view controller. This is not ideal, as I only had endpoints that would download i.e. all photos instead of just the photos for one particular album. In a real-world application this would probably the case and therefore I decided to do it this way. This causes delay when first loading the photo table. All subsequent loads should be fast.
* For the caching of the images I use the open source Swift cache Kingfisher.
* I did the title localization using a strings file. I could've also done it directly inside the storyboard, but I prefer the other approach.
* To persist the data I store it locally in Core Data. I used mogenerator to generate the model files.
* I'm using the network activity indicator to, well, indicate network activity.
* I ran into an issue with the unit tests. It seems to be an issue with the current version of Xcode.

If you have any further questions feel free to email me at <florian@heiber.me>. Thank you for your time!
