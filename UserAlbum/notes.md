In your source files, add the following code:

import Kingfisher

imageView.kf_setImageWithURL(NSURL(string: "http://your_image_url.png")!)
In most cases, Kingfisher is used in a reusable cell. Since the downloading process is asynchronous, the earlier image will be remained during the downloading of newer one. The placeholder version of this API could help:

imageView.kf_setImageWithURL(NSURL(string: "http://your_image_url.png")!, placeholderImage: nil)
By default, Kingfisher will use absoluteString of the URL as the key for cache. If you need another key instead of URL's absoluteString, there is another set of APIs accepting Resource as parameter:

let URL = NSURL(string: "http://your_image_url.png")!
let resource = Resource(downloadURL: URL, cacheKey: "your_customized_key")

imageView.kf_setImageWithResource(resource)
It will ask Kingfisher's manager to get the image for the "your_customized_key" from memory and disk first. If the manager does not find it, it will try to download the image at the URL, and store it with cacheKey ("your_customized_key" here) for next use.