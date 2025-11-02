# sevka

Sevka is a subset of [Iosevka](https://typeof.net/Iosevka/) intended for online distribution. It constrains Iosevka to five weights (light, regular, medium, semibold, bold), one width (normal), and two slopes (upright, italic), resulting in 10 fonts against Iosevka's original 54.

To further reduce filesize, all OpenType features, character variants, and ligations are disabled at build time, and the fonts are reduced after build to the [US-ASCII](https://en.wikipedia.org/wiki/ASCII) or [Latin-1](https://en.wikipedia.org/wiki/ISO/IEC_8859-1) character sets. As a result, a basic TrueType bundle consisting of regular, italic, bold, and bold italic weighs only 139.4 kB (ASCII) or 258.2 kB (Latin) against Iosevka's original 40.4 MB. In WOFF2 format, the size is further compressed to 57.8 kB (ASCII) and 100.9 kB (Latin), allowing fonts to load in a split second.

The font comes in three versions:

* Sevka: sans-serif, quasi-proportional
* Sevka Slab: serif, quasi-proportional
* Sevka Fixed: sans-serif, fixed width

Sevka and Sevka Slab are intended for body text and headings. Sevka Fixed is the true monospaced version, to be used for code, tables, and other environments where column width is constant.

## Specimen

![](https://github.com/piazzai/sevka/blob/master/screenshot.png)

## Motivation

Iosevka is a marvelous typeface. It is open-source, looks stunning, and comes in a variety of weights, widths, and slopes, with fixed-space and quasi-proportional versions, hundreds of character variants, ligatures, and a matching slab-serif family. Despite this plethora of options, it remains consistent, space-efficient, and mathematically precise.

Such unwavering precision gives Iosevka the sort of timeless quality you sometimes get when a computer scientist dabbles in type design, as was the case of [Computer Modern](https://en.wikipedia.org/wiki/Computer_Modern) a few decades back. But while Computer Modern was inspired by the look of classic 19th-century hot-metal type, and understandably looks awkward on the web, Iosevka is a contemporary typeface that feels as much at home in a web browser as it does on paper or in a terminal emulator.

There is one problem with Iosevka's use on the web, however. Due to extensive Unicode coverage, multi-language support, ample customization options, OpenType features, and ligation sets, the font is not exactly lightweight. Just the vanilla face (regular weight, normal width, upright slope, in TrueType format) is 9.9 MB. If we want a minimal bundle that includes regular, italic, bold, and bold italic, which is necessary to correctly render markdown documents like this, the total filesize climbs to 40.4 MB. And if we simply a Iosevka package off the shelf—say, [Iosevka Slab](https://github.com/be5invis/Iosevka/releases/download/v33.3.3/PkgTTF-IosevkaSlab-33.3.3.zip)—and load it with all its bells and whistles, we are looking at a whopping 546.1 MB. This is simply unacceptable for a website, most of which don't even need full Unicode encoding as they only need to render ASCII or Latin characters.

Sevka is a solution to this problem. It is a heavily streamlined Iosevka build that preserves only the most useful weights and shapes, enabling text optimization at small and display sizes, but drops all unnecessary glyphs and uneconomical features. This allows for a much leaner font that retains Iosevka's charm at a fraction of the bandwidth.

## Build

Prebuilt font files are included in the `dist` folder. If you'd like to replicate the build process, then install the dependencies [node.js](https://nodejs.org/), [ttfautohint](https://freetype.org/ttfautohint/), and [glyphhanger](https://www.zachleat.com/web/glyphhanger/), and take a look at Iosevka's own [docs](https://github.com/be5invis/Iosevka/blob/main/doc/custom-build.md#customized-build).

Then, clone the Iosevka repo and `cd` into it after copying Sevka's build plans.

```bash
git clone --depth 1 https://github.com/be5invis/Iosevka
cp private-build-plans.toml Iosevka/private-build-plans.toml
cd Iosevka
```

Install local dependencies and build the fonts.

```bash
npm install
npm run build -- contents::Sevka
npm run build -- contents::SevkaSlab
npm run build -- contents::SevkaFixed
```

Run the `subset.sh` script to subset the files you've built to ASCII and Latin charsets.

```bash
bash ../subset.sh
```

Copy the resulting fonts into the root directory, `cd` back, and delete the Iosevka repo.

```bash
mv dist/ascii ../ascii
mv dist/latin ../latin
cd ..
rm -rf Iosevka
```

Done! Your files are in the `ascii` and `latin` folders.

## Usage

Copy the fonts to your project's asset directory and load them with the CSS blocks included in `ascii/sevka.css` or `latin/sevka.css`. Alternative stylesheets can be found in `ascii` and `latin`'s subfolders, in case you only want to load the TrueType or WOFF2 versions.

You can also use the more compact Sass syntax:

```scss
$faces: (
  Sevka: "Sevka",
  SevkaSlab: "Sevka Slab",
  SevkaFixed: "Sevka Fixed",
)

$styles: (
  normal: "",
  italic: "Italic",
);

$weights: (
  "Light": 300,
  "Medium": 500,
  "SemiBold": 600,
  "Bold": 700,
);

@each $face, $face-value in $faces {
  @font-face {
    font-family: "#{face-value}";
    font-display: swap;
    font-style: normal;
    font-weight: 400;
    src: url("path/to/fonts/#{face}-Regular.ttf") format("truetype") url("path/to/fonts/#{face}-Regular.woff2") format("woff2");
  }

  @font-face {
    font-family: "#{face-value}";
    font-display: swap;
    font-style: italic;
    font-weight: 400;
    src: url("path/to/fonts/#{face}-Italic.ttf") format("truetype") url("path/to/fonts/#{face}-Italic.woff2") format("woff2");
  }

  @each $style, $style-value in $styles {
    @each $weight, $weight-value in $weights {
      @font-face {
        font-family: "#{face-value}";
        font-display: swap;
        font-style: #{$style};
        font-weight: #{$weight-value};
        src: url("path/to/fonts/#{face}-#{$weight}#{$style-value}.ttf") format("truetype") url("path/to/fonts/#{face}-#{$weight}#{$style-value}.woff2") format("woff2");
      }
    }
  }
}
```
