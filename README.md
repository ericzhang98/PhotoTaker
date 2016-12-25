Photo Taker

How to build:
Open up the program in XCode 8 and run the program with an actual iPhone
attached, since you can't test the photo taking functionality on the simulator.
Pressing the big "Say Cheese!" button uses the front camera to take 10 pictures
over the course of 5 seconds. After it's done, you can view the pictures by
pressing the "Look at photos" button (tap to move forward). This data is stored
in the app's keychain through the KeychainManager class and persists through app
sessions. Each new set of 10 photos replaces the old set of photos.


Further Considerations:
Overall, the programming challenge was tough. Not really in a logical/abstract
way but like a nitty-gritty way, where I had to learn some API/syntax and then
get it working. This is usually how my experience with hackathons end up feeling
like too, where I start off with cool ideas, but most of the effort goes into
trying to getting new things to just work.
The AVFoundation stuff was new to me and I spent a lot of time implementing it.
Most of the hassle came from an inability to easily test it at first. I tried
displaying the first image, but it would always end up as a black screen. It turns
out that the camera takes a few milliseconds to boot up, so you have to wait a
tiny bit before taking the first photo. 
For the secure storage part, I spent the majority of my time reading up on it
and figuring out what the heck was going on before I started any coding. This
made it easier to get it working (compared to AVFoundation) because I found a solid
guide for using KeychainStorage, which layed out a majority of the code:
https://flyingmoose.co/blog/ios/swift-2-guide-to-keychain-encryption-part-one.html

In the end, I spent around 6 hours on this app to get it working. I learned how
to interact with the iPhone hardware through AVFoundation and keychain storage
through the Keychain Services API. The camera was super cool once I got it
working because I could see some physical action/response from the code.
