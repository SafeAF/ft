The size of an advertising banner often depends on various factors, such as the design of the site, the intended audience, and the platform (desktop, mobile, or both). However, there are some industry-standard sizes for web banners that you might consider:

### Common Web Banner Sizes:

1. **Leaderboard**: 728x90 pixels
2. **Medium Rectangle**: 300x250 pixels
3. **Large Rectangle**: 336x280 pixels
4. **Half-Page or Filmstrip**: 300x600 pixels
5. **Wide Skyscraper**: 160x600 pixels
6. **Mobile Leaderboard**: 320x50 pixels
7. **Large Mobile Banner**: 320x100 pixels

### Things to Consider:

- **Responsiveness**: Since you're using Bootstrap, you'll likely want to ensure that the banner is responsive. You could use Bootstrap's responsive classes or write custom media queries for this.
  
- **Visibility**: Make sure the banner is large enough to be noticeable but not so large that it becomes obtrusive or interferes with the user experience.
  
- **Aspect Ratio**: Maintaining a standard aspect ratio is often advisable unless you have a very specific design requirement that necessitates otherwise.

- **Placement**: Common placements are at the top of the page (Leaderboard), within the content (Medium Rectangle), or in the sidebar (Wide Skyscraper).

Here's a simple example using Bootstrap to create a responsive ad banner:

```html
<!-- HTML -->
<div class="container">
  <div class="row">
    <div class="col-12">
      <div class="ad-banner">
        <!-- Your ad code here -->
      </div>
    </div>
  </div>
</div>
```

```css
/* CSS */
.ad-banner {
  width: 100%;
  max-width: 728px;  /* Or any maximum size you prefer */
  height: auto;
}
```

Remember, the ultimate size and placement depend on your specific needs, so feel free to adjust these suggestions accordingly.