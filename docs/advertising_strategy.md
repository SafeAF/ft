Integrating an advertising platform into a multifaceted application such as yours involves various considerations including user experience, business logic, and technical implementation. Below are some general strategies categorized by these areas.

### User Experience

1. **Ad Placement**: Decide where the ads will be most effective without hampering user experience. Adverts could be integrated into:
    - Product listings
    - Job board entries
    - Business directory listings
    - News articles

2. **Responsive Design**: Ensure that ads are mobile-friendly and that their layout adjusts based on the device.

3. **User Relevance**: Utilize user data to display relevant ads. For instance, show job-related ads in the job board section, local business ads in the business directory, etc.

### Business Logic

1. **Ad Rotation and Timing**: Determine how often ads will be rotated and what algorithm will be used to display them.

2. **Impressions and Clicks**: Track impressions and clicks to understand ad performance.

3. **Budget and Bidding**: If multiple advertisers are competing for the same space, you might implement a bidding system.

4. **Targeting**: Provide options for advertisers to target their ads based on user behavior, location, or other metrics.

### Technical Implementation

1. **Ad Server**: You could use an internal ad server that pulls ads from your database and serves them in the relevant spots in real-time.

2. **Tagging and Tracking**: Implement tags to track user interaction with ads.

3. **APIs**: If your advertising component is decoupled from your main application, you'll need APIs to fetch relevant ads.

4. **Caching**: To improve performance, you could cache ads that are frequently served.

5. **AB Testing**: Use AB tests to understand what formats and placements work best.

#### Code-Level Integration:

- **Listing and Job Board**: For every N listings, inject an ad from the campaign targeted at job seekers or potential customers.
    ```ruby
    listings.each_with_index do |listing, index|
      display_advert if index % N == 0
    end
    ```
  
- **Business Directory**: Ads could be shown as promoted businesses at the top of the directory list.

- **Local News Section**: Integrate ads within the news feed or as banners.

You can model this data to fit these sections and use controllers to pull in the relevant adverts based on the advertiser's targeting preferences, the campaign's active time frame, and other such criteria.

The complexity of your integration would depend on how advanced you want your ad platform to be. Start simple and then incrementally add features like targeting, bidding, and advanced tracking.