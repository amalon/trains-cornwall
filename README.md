
Cornwall & Isles of Scilly Train Ticket Board Game
==================================================

A custom board game map and train ticket cards for Cornwall & the Isles of
Scilly (UK), inspired by the *Ticket to Ride* Board Games published by *Days of
Wonder* (with whom I am not affiliated).


License
-------

The `Makefile` is released under the [GNU General Public License, version 2].

All other content is released under the [Creative Commons Attribution-Share
Alike 3.0 Unported] license (see `LICENSE.md`) unless otherwise stated (see
Sources below).

 - Copyright © 2020 James Hogan <james@albanarts.com>
 - Background maps contain Ordnance Survey data © Crown copyright and database
   right
 - Original Scilly flag by Steve Duncan
 - Original locomotive by Panther


Prerequisites
-------------

You need the following fonts installed to open or build the designs:

 - [Kaushan Script Regular] (fontlibrary.org)

 - [Anton] (fonts.google.com)

You need the following software packages installed to build the designs on
Linux:

 - [Inkscape](https://inkscape.org/) (at least version 1) is required by the
   `Makefile` to convert the SVG files to PNG.

   Ensure `inkscape` is in your `$PATH`.

 - [Imagemagick](https://www.imagemagick.org/) (specifically the "`convert`"
   utility) is required by the `Makefile` to convert the PNG to a PDF.

   Ensure `convert` is in the `$PATH`.

 - [pdfposter](https://gitlab.com/pdftools/pdfposter.git) is required by the
   `Makefile` to tile the large PDF onto multiple pages.

   Ensure `pdfposter` is in the `$PATH`.

 - [TeX Live](https://tug.org/texlive/) (specifically `pdflatex`) is required
   by the `Makefile` to add margins and cropping marks to the tiled PDF.

   Ensure `pdflatex` is in the `$PATH`.


Building
--------

The default `Makefile` targets generate a tiled A4 PDF of the board in
`outputs/Cornwall-300dpi-a4.pdf`, and a paged set of destination tickets in
`outputs/cornwall_tickets-300dpi.pdf`:

```shell
$ make
```

To open `cornwall_tickets.svg` you first need to generate the background from
`ticket_background.svg`. This can be done with the "`prepare`" `Makefile`
target:

```shell
$ make prepare
```

Other `Makefile` targets are as follows (where XX is the DPI, either 75,
150, or 300):

 - `all`

   All outputs at all DPI levels.

 - `board`

   Just the board PDF at the default DPI level.

 - `tickets`

   Just the tickets PDF at the default DPI level.

 - `png`

   PNG files for each of the above DPI levels.

 - `pdf`

   PDF files of the above PNG files and corresponding A4 tiles for printing.

 - `outputs/Cornwall-XXdpi.png`

   A PNG of the board at the specified DPI.

 - `outputs/Cornwall-XXdpi.pdf`

   A single page PDF of the board at the specified DPI.

 - `outputs/Cornwall-XXdpi-a4.pdf`

   A tiled multipage PDF of the board at the specified DPI, for A4 printing.


Sources
-------

I've tried to use free sources wherever possible. The originals can be found in
the `originals/` directory. Modifications can be found in the `modified/`
directory.

The following table lists all the sources, more details below:

Source				| License		| Attribution
--------------------------------|-----------------------|-----------------------
[Puffin]			| PD			| Aki G. Karlsson
[Dolphin]			| PD			| cactus cowboy
[Lighthouse]			| PD			| '*The History of Plymouth*', Richard Worth, 1890.
[Ship]				| PD			| 
[Flag of Cornwall]		| PD			| Jon Harald Søby
[Flag of Devon]			| PD			| Greentubing
[Flag of USA]			| PD			| US Federal Government
[Map of Cornwall]		| [CC BY-SA 3.0]	| Contains Ordnance Survey data © Crown copyright and database right
[Map of Isles of Scilly]	| [CC BY-SA 3.0]	| Contains Ordnance Survey data © Crown copyright and database right
[Flag of Isles of Scilly]	| [CC BY-SA 3.0]	| Steve Duncan
[Steam Locomotive]		| [CC BY-SA 3.0]	| Panther
[Kaushan Script Regular]	| [OFL]			| Pablo Impallari
[Anton]				| [OFL]			| Vernon Adams

 - The graphics on the sea ([Puffin], [Dolphin], [Lighthouse], [Ship]) are taken
   from [publicdomainvectors.org] in SVG form and are claimed to be in the
   public domain.

   The only changes are colour changes to the lighthouse ([Lighthouse]) and the
   ship ([Ship]).

   [Puffin]: https://publicdomainvectors.org/en/free-clipart/Puffin-bird-vector-illustration/31686.html
   [Dolphin]: https://publicdomainvectors.org/en/free-clipart/Dolphin-smiling/68665.html
   [Lighthouse]: https://publicdomainvectors.org/en/free-clipart/Old-lighthouse/69935.html
   [Ship]: https://publicdomainvectors.org/en/free-clipart/Bark-ship-vector-drawing/14591.html

 - The [Flag of Cornwall], [Flag of Devon], and [Flag of USA]) are taken from
   [Wikipedia], and are placed in the public domain.

   They have been modified to make them circular.
   They are then used as the icons for the towns and cities on the board and the
   destination tickets.

   [Flag of Cornwall]: https://en.wikipedia.org/wiki/File:Flag_of_Cornwall.svg
   [Flag of Devon]: https://en.wikipedia.org/wiki/File:Flag_of_Devon.svg
   [Flag of USA]: https://en.wikipedia.org/wiki/File:Flag_of_the_United_States.svg

 - The [Map of Cornwall], the [Map of Isles of Scilly], the [Flag of Isles of
   Scilly] and the image of a [Steam Locomotive] are taken from [Wikipedia], and
   are licensed under the [Creative Commons Attribution-Share Alike 3.0
   Unported] license.

   The maps have been simplified using Inkscape and the colours have been
   altered. They are then used as the background maps for the board and the
   destination tickets.

   The [Flag of Isles of Scilly] has been modified to make it circular, with the
   stars moved so they remain visible.
   It is then used as the icons for the islands on the board and the destination
   tickets.

   The outline of the [Steam Locomotive] has been traced.
   It is then used as the locomotives on ferry routes on the board, and in the
   table of scores for different route lengths on the board.

   [Map of Cornwall]: https://en.wikipedia.org/wiki/File:Cornwall_UK_district_map_(blank).svg
   [Map of Isles of Scilly]: https://en.wikipedia.org/wiki/File:Isles_of_Scilly_UK_location_map.svg
   [Flag of Isles of Scilly]: https://en.wikipedia.org/wiki/File:ScillonianCross.svg
   [Steam Locomotive]: https://en.wikipedia.org/wiki/File:Steam_locomotive_scheme_new.png

 - Most of the text uses the [Kaushan Script Regular] font, but the scores on
   the tickets use the [Anton] font. Both are released under the [SIL Open Font
   License].

   [Kaushan Script Regular]: https://fontlibrary.org/en/font/kaushan-script
   [Anton]: https://fonts.google.com/specimen/Anton

[CC BY-SA 3.0]: https://creativecommons.org/licenses/by-sa/3.0/
[Creative Commons Attribution-Share Alike 3.0 Unported]: https://creativecommons.org/licenses/by-sa/3.0/
[GNU General Public License, version 2]: https://www.gnu.org/licenses/old-licenses/gpl-2.0.html
[OFL]: https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL
[SIL Open Font License]: https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL
[Wikipedia]: https://publicdomainvectors.org
[publicdomainvectors.org]: https://publicdomainvectors.org
