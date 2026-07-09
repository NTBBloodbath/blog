# Wistaria

A soft theme with lavender tones and a personal notebook feel. It comes with two collections: `journal` for longer, more polished articles and essays, and `log` for shorter, more informal notes, thoughts, and micro-entries. Wistaria is designed to be a cozy digital space for your writing, with a focus on readability and aesthetics.

## Installation

```bash
lith theme pull github:norgolith/wistaria
```

> [!IMPORTANT]
>
> Wistaria requires Norgolith >= 1.0 in order to work.

## Usage

After installing, configure your site as described below. If you plan to modify the CSS, see the [Tailwind Reloading](#tailwind-reloading) section.

### Configuration

Add the following fields to your `norgolith.toml`:

```toml
# Categories directory
categoriesDir = 'library'

# Posts collections
# Journal: Longer, more polished articles and essays.
# Log: Shorter, more informal notes, thoughts, and micro-entries.
[[collections]]
name = 'journal'
dir  = 'journal'

[[collections]]
name = 'log'
dir  = 'log'

[extra]
license = "GPLv2" # Optional
favicon_path = "/assets/norgolith.svg" # Fallback to default favicon
footer_author_link = "https://github.com/NTBBloodbath" # Optional
enable_mermaid = true # Enable Mermaid.js for diagrams

[extra.nav]
Journal = { url = "/journal", icon = "news" }
Log = { url = "/log", icon = "notebook" }
Library = { url = "/library", icon = "book-2" }
# About = { url = "/about", icon = "info-circle" }

[extra.footer]
# Name = { url = "https://example.com", icon = "link" }
# GitHub = { url = "https://github.com/user/repo", icon = "brand-github" }

# Tag colors: accepts either theme color tokens or raw CSS color values.
#
# Theme tokens (adapt automatically to dark mode):
#   primary, secondary, green, blue, violet, yellow, red
#
# Raw CSS values (static, no dark mode adaptation):
#   #rrggbb, rgb(...), hsl(...), oklch(...)
#
#[extra.tags]
#log = 'red'
#essay = 'primary'
#announcement = '#72ff47'
```

#### Syntax Highlighting

Wistaria ships a custom `prism-wistaria.css` and `tree-sitter-theme.css` adapted to its color palette.

##### PrismJS

Just set the highlighter engine configuration option to `prism`. You will have to manually add the
`+html.class line-numbers` to each code block, and `+html.class diff-highlight` for diff filetype
syntax highlighting.

<img width="1372" height="238" alt="image" src="https://github.com/user-attachments/assets/bd1c9e8e-e7cd-4b81-8805-e3f3cb78af9b" />

##### Tree-sitter

To use it with the tree-sitter highlighter plugin:

```toml
[plugins.norgolith-tree-sitter-highlight]
css-path = "/assets/css/tree-sitter-theme.css"
line-numbers = true
line-numbers-start = 1
```

> [!NOTE]
>
> Install the plugin with `lith plugin install norgolith-tree-sitter-highlight`. The `css-path` option
> tells the plugin to use the theme's CSS instead of its default. The path is a URL path resolved
> by the web server, not a filesystem path.

### Templates

Wistaria provides these templates:

```
templates
├── partials
│   ├── footer.html       <- Footer content
│   └── nav.html          <- Header navbar
├── shortcodes
│   └── entry_card.html   <- Reusable entry card (used via include)
├── base.html             <- Main template (extends others)
├── categories.html       <- Categories listing page (Library)
├── category.html         <- Single category posts listing
├── default.html          <- Default template for all content
├── index.html            <- Homepage (hero + recent posts)
├── journal.html          <- Journal collection
├── log.html              <- Log collection
├── entry.html            <- Blog/journal entry
└── 404.html              <- Error page (optional)
```

The homepage (`/`) uses `index.html` — set `layout: index` in your root `index.norg` content file. It shows a hero area with your content, then recent journal and log posts with full entry cards.

To use a template, set the `layout` metadata in your content files. For example, in a journal/log post:

```norg
layout: entry
```

> [!TIP]
>
> 1. The `categories` template is used for the categories listing page, and the `category` template is used for the category posts listing page. You can customize these templates to change how your categories and their posts are displayed.
> 2. The entry card component (`shortcodes/entry_card.html`) is used by `journal.html`, `log.html`, `category.html`, and `index.html`. Customize it once to change how all post listings look.
> 3. Wistaria expects your journal entries in the `content/journal` directory and your log entries in the `content/log` directory, as specified in the `collections` configuration. Make sure to place your content files accordingly for them to be rendered with the correct templates.

#### Feature image / hero

Add an `image` field to your entry metadata to show a hero image between the header (title, date, tags) and the article body:

```norg
@document.meta
image: https://example.com/path/to/image.jpg
@end
```

The image is rendered full-width with rounded corners. Optional — entries without `image` display as normal.

#### Post navigation

Entry pages show prev/next links at the bottom using the post's chronological siblings within the same collection (journal or log). Navigates by `created` date. Automatically hidden at collection boundaries.

### MermaidJS Support

Wistaria comes with opt-in support for MermaidJS flowcharts. You can use mermaid charts through embedded HTML in your norg content if you set the `enable_mermaid` option to `true` in the `extra` table of your configuration file:

```org
@embed html
<pre class="mermaid">
  flowchart LR
  A[HTML Fragment] --> B[Tera Engine]
  C[Validated Metadata] --> B
  D[Site Config] --> B
  E[Post Collection] --> B
  B --> F[Layout Template]
  F --> G[Final HTML]
</pre>
@end
```

### Additional Styling

Wistaria provides some additional styling options for blockquotes that can be used with `+html.class` tags in your norg content.

#### Blockquotes

Styled callout variants with Tabler Icons and matching border/accent colours:

- `tip` (green, bulb icon)
- `note` (blue, info circle icon)
- `important` (violet, exclamation circle icon)
- `warning` (yellow, alert triangle icon)
- `error` (red, circle-x icon)

Use `+html.class` before a norg blockquote:

```norg
+html.class tip
> This tip uses the bulb icon and green accent.
```

<img width="1380" height="340" alt="image" src="https://github.com/user-attachments/assets/e29d8368-3934-4e3a-aafb-43b6608f1668" />

#### Tags/categories pills

Wistaria provides a `tags` table in the configuration where you can assign colors to specific tags or categories. You can use either theme color tokens (like `primary`, `secondary`, `red`, etc.) or raw CSS color values (like `#rrggbb`, `rgb(...)`, etc.). These colors will be applied to the corresponding tags/categories in your content. For example:
```toml
[extra.tags]
log = 'red'
essay = 'primary'
announcement = '#72ff47'
```

<img width="1392" height="485" alt="image" src="https://github.com/user-attachments/assets/8fa48976-be3a-4c1b-a5b1-5aadab9be835" />

### Interactive Features

Wistaria includes several Alpine.js-powered interactive enhancements:

- **Copy button for code blocks** - each `pre > code` gets a copy button (top-right corner, visible on hover). Click copies the code to clipboard and briefly shows a check mark.
- **Back-to-top button** - appears at bottom-left after scrolling past 400px. Smooth-scrolls to top on click.

### Tailwind Reloading

By default, Tailwind's configuration in Wistaria watches content files and templates. Each new class added to content using a `+html.class` tag will be included in the styling file.

For site development, install the TailwindCSS CLI and run:
```sh
tailwindcss -i theme/assets/css/tailwind.css -o theme/assets/css/styles.min.css --minify --watch
```

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to open an issue or pull request.

## License

Wistaria is licensed under MIT license.
