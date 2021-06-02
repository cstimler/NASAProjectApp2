To build and run the app, double click on the file "NasaProjectApp.xcodeproj" in the NasaProjectApp directory.  
Your computer should recognize this file as an XCode file and should then bring up XCode, which will load the file.
You can run this App in the XCode simulator by choosing a virtual device (or attaching your actual devide to your computer)
and pressing the "run" key.  I hope you enjoy using this app!

The NASA photo app allows the user to explore and save/share edited photos from the entire online database 
of the NASA "Photo of the Day", which has been running continuously from June 16, 1995 to the present.  The
opening screen provides two choices - a user could enter a date and click the "I'm Ready" button which will lead to a 
table of photos, whose thumbnail is displayed on the left of each row, followed by the title of the photo to its right.  
Alternatively, the user can click the little red heart icon in the upper right which brings the user to the "Favorite Pics" menu
(more on the "Favorite Pics" menu below).  The app loads 8 photos each time the "I'm Ready" button is pressed; the 
latest date availabe to choose is therefore about 8 days prior the current date.  After the user clicks on the "I'm Ready"
button, she can elect to load more photos into the table by clicking the "Load More Images" button at the bottom of the
table.  This can be repeated for as many times as desired.  The user can scroll through the table and select (click on)
a row which will then display a full screen photo.  On this next "staging" screen there are several choices.  The user may 
rotate the photo to optimize its appearance.  By tapping on the screen, the photo will be displayed in a variety of aspect
options (aspect fill, aspect fit, scale to fill).  Also, by pressing the "Title?" button the appearance of a title will be toggled 
near the top of the photo.  The title is editable, so the user can keep the title as is, add an extra comment at the end, or
completely replace the title with user comments (there can be up to four lines of comments).  When the user is finished 
editing the title, they can press on the "return" button on the keyboard and the keyboard will retract.  If the user desires to 
see more information about this photo, she can press the info button ("i" in a circle).  This will bring up a small temporary
scrollable window which the user can read to learn more about the photo.  To dismiss the info window the user can press
on the "i" button again, or click in an area of the photo outside of the title.  When the user is ready, she can press the add 
"+" button which will add the edited photo to the "Favorite Pics" menu.  This also saves the pic to Core Data.  If this photo
has been added previously, an alert will display to inform the user that the photo cannot be added because it has already
been saved before.  There is also a little red heart icon that will take the user to the "Favorite Pics" menu.  (Note: A few
of the photos in the table are actually "videos" which play in YouTube or Vimeo; these are indicated by the "YouTube"
icon in the table; clicking on one of these will bring up the Safari browser and the user can watch the videoo.  Dismissing
the Safari browser returns the user back to the photo table.)

The Favorite Pics menu (att the little red heart destination) provides a rotatable collection view that displays all the saved
edited photos.  Upon clicking on one of these photos, the user is next taken to a detail view with a full size pic as it was 
saved (including titles, comments, correct aspect ratios, etc.).  When the user is ready, she can press the share button
(rectangle with an arrow pointing up) which will bring up the iPhone's share panel from with the edited phto can be copied,
attached to an email or a message, shared on social media. etc.  Alternatively, if the user desires to delete the pic from the 
collection, the user may select the "Delete?" button.  A confirmation alert is displayed, and if the user confirms then the pic 
is deleted from both the Core Data and therefore also from the collection view.  There is also an "i" information button which
again provides information about the pic; in addition, it also provides the title and the date ( unlike the “i” button in the staging 
view) since these informations are not accessible at this point (and just in case the user wants to go back and redo the pic).  
A “Back” button takes the user back to the Favorite Pics collection view, which displays the new view where the deleted 
photo (if there was a deletion) is no longer visible.  If the user wishes to browse more NASA photos, there is a “calendar” icon
in the upper right hand of the Favorite Pics menu which takes the user back to the opening screen where another date can be
chosen for exploration.  

Notes to instructor:

1. App should give an alert if there is no connectivity, after 10 seconds.
2. Photo placeholders are used in the table view, and a prominent activity indicator is used while waiting for the detail view 
to load in the staging view.
3. In addition to Core Data, persistent state is also maintained with NSUserDefaults that stores the latest date searched which is 
then loaded into the date picker when the app is restarted.
4. Data loading code is placed in SceneDelegate instead of AppDelegate as is required for iOS > 12, also the date picker I 
used requires iOS > 13.4 just fyi.
5. I learned a lot while making this app, including how to use unwind segues (including modal presentations), how to correctly 
use a NSCache object (which ensures that the photos in the tableview load smoothly even with rapid scrolling of photos on and 
off screen), how to resize photos in order to increase the effectiveness of the cache, how to manage/format dates and do date 
arithmetic while using a UIDatePicker object, how to pass a dataController between views when using a “back” button (and how 
to address view controllers depending upon their location in the stack), the benefits of embedding one NavigationController 
within another (such as preventing a continuous string of back buttons where these are not desired), and even how to patch 
up a bug in Apple’s iOS code (see comment in collectionView override function “cellForItemAt” in the FavoritesCollectionViewController).
6. Many, many more options can be added to the app to make it even more fun to use.  I am contemplating adding an intro 
“splash screen”, allowing user to toggle title fonts and/or colors when pressing the “Title?” Button, providing an optional 
“frame” around the pic, and possibly providing a default “pic” for YouTube/Vimeo videos (maybe a thumbnail of the video with 
an embedded link) so that users can even store and share thumbnail pics of videos with links (for those YouTube and/or Vimeo 
videos) though I’m not too sure how to do this yet.
7. I am including my API-Key in my submission for easier checking on your part.  Of course, please keep this confidential.  
I became aware of the problem of accidentally uploading my API-Key to Github while working on these projects (I’m still 
struggling with using .gitignore in Xcode)!  Thanks.
8. I’d appreciate any comments to assist in making this app “App Store Ready” and your opinion  Thanks.
9. Just curious, does Udacity have any “Hall of Fame” featuring apps that have been submitted to the App 
Store made by graduates?
10. (NEW) Thank you very much for the constructive criticism of the need for more alerts.  There is already an alert for lost
connectiving prior to selecting the calendar date.  I have now added alerts that will occur in any of the following circumstances:
a) if connectivity is lost prior to pressing the "Load More Photos" button at the bottom of the tableview.
b) if connectivity is lost after pressing the "Load More Photos" button BUT prior to finishing the photo download.  This same
alert will also be triggered if the hosting NASA website has a missing or bad url.  For example, I have since discovered that for 
the dates June 16, 2014 and June 17, 2014 there is an error in the NASA website with badly formatted urls being provided.  
A search that including these date will now result in this error.  I have chosen to re-enable the download button after this error just in case the error happened due to only one or two missing urls in which case the user can continue to browse.
c) if connectivity is lost prior to completing the download of the selected photo from the table view.
I believe these alerts cover any possible case.

