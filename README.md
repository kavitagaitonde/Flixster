# Project 1 - Flixster

*Flixster* is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: *11* hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [X] User can view movie details by tapping on a cell.
- [X] User sees loading state while waiting for the API.
- [X] User sees an error message when there is a network error.
- [X] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [X] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [X] Implement segmented control to switch between list view and grid view.
- [X] Add a search bar.
- [X] All images fade in.
- [X] For the large poster, load the low-res image first, switch to high-res when complete.
- [X] Customize the highlight and selection effect of the cell.
- [] Customize the navigation bar.


## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://i.imgur.com/X5wuMX8.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='https://i.imgur.com/Mf0oLoi.png' title='Network Error screenshot' width='' alt='Network Error screenshot' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

#1 I had trouble add the UISearchBar to the UICollectionView. In the end I ended up adding it to the Header view.
#2 Tab bar item titles were not showing up. Then I moved the setting of the title after the image, and it works now. 

## License

    Copyright 2017 Kavita Gaitonde

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
