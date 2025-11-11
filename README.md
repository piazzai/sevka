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

Iosevka is a marvelous typeface. It is open-source, it looks stunning, and it comes in a variety of weights, widths, and slopes, with fixed-space and quasi-proportional versions, hundreds of character variants, ligatures, and a matching slab-serif family. And despite this plethora of options, it remains consistent, space-efficient, and precise. It has the sort of timeless appeal we sometimes get when a computer scientist dabbles in type design, as was the case of [Computer Modern](https://en.wikipedia.org/wiki/Computer_Modern) a few decades back. But while Computer Modern was inspired by the look of 19th-century metal type and looks awkward on the web, Iosevka is a contemporary typeface that feels as much at home in a web browser as it does on paper or in a terminal window.

There is one problem with Iosevka's use on the web, though. Due to extensive Unicode coverage, language support, customization options, OpenType features, and ligature sets, its filesize is massive. Just the vanilla face (regular weight, normal width, upright slope, in TrueType format) is 9.9 MB. This is unacceptable for a website, especially if it doesn't even need full Unicode encoding because it only needs to render ASCII or Latin characters.

Sevka is a solution to this problem. It is a heavily streamlined Iosevka build that only retains weights and shapes commonly found on the web, dropping unnecessary glyphs and uneconomical features. This allows for a much leaner font that requires minimal bandwidth but still allows for text optimization and various display sizes.

## Build

Prebuilt font files based on [Iosevka v33.3.3](https://github.com/be5invis/Iosevka/releases/tag/v33.3.3) are included in the `dist` folder. If you'd like to replicate the build process, install [node.js](https://nodejs.org/), [ttfautohint](https://freetype.org/ttfautohint/), and [glyphhanger](https://www.zachleat.com/web/glyphhanger/). You might want to build the files yourself if you want a different release of Iosevka, or if you'd like to reintroduce particular features or character variants. If this is the case, please [read the docs](https://github.com/be5invis/Iosevka/blob/main/doc/custom-build.md#customized-build) and create new build plans through Iosevka's [customizer tool](https://typeof.net/Iosevka/customizer).

When you have your build plans, clone the Iosevka repo, `cd` into it, and copy the plans.

```bash
git clone --depth 1 https://github.com/be5invis/Iosevka
cd Iosevka && cp ../private-build-plans.toml private-build-plans.toml
```

Install local dependencies and build the fonts.

```bash
npm install
npm run build -- contents::Sevka
npm run build -- contents::SevkaSlab
npm run build -- contents::SevkaFixed
```

Run `subset.sh` to reduce the files you've just built to ASCII and Latin characters.

```bash
bash ../subset.sh
```

Copy the resulting fonts into the root directory, `cd` back, and delete the Iosevka repo.

```bash
mv dist/ascii ../ascii
mv dist/latin ../latin
cd .. && rm -rf Iosevka
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
);

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
    font-family: "#{$face-value}";
    font-display: swap;
    font-style: normal;
    font-weight: 400;
    src: url("path/to/fonts/#{$face}-Regular.ttf") format("truetype") url("path/to/fonts/#{$face}-Regular.woff2") format("woff2");
  }

  @font-face {
    font-family: "#{$face-value}";
    font-display: swap;
    font-style: italic;
    font-weight: 400;
    src: url("path/to/fonts/#{$face}-Italic.ttf") format("truetype") url("path/to/fonts/#{$face}-Italic.woff2") format("woff2");
  }

  @each $style, $style-value in $styles {
    @each $weight, $weight-value in $weights {
      @font-face {
        font-family: "#{$face-value}";
        font-display: swap;
        font-style: #{$style};
        font-weight: #{$weight-value};
        src: url("path/to/fonts/#{$face}-#{$weight}#{$style-value}.ttf") format("truetype") url("path/to/fonts/#{$face}-#{$weight}#{$style-value}.woff2") format("woff2");
      }
    }
  }
}
```
