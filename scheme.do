version 15
foreach package in grstyle colorpalette{
	capture which `package'
	if (_rc != 0){
		noisily display "Installing package `package'"
		if "`package'" == "colorpalette" {
			ssc install palettes
		}
		else{
			ssc install `package'
		}
	}
}

* Starting from scratch to avoid conflicts
grstyle clear
set scheme s2mono
grstyle init

****** Background, coordinate system ******
grstyle set plain, box
grstyle linewidth major_grid vvthin
grstyle color major_grid black%50
grstyle yesno draw_major_hgrid yes
grstyle yesno grid_draw_min yes
grstyle yesno grid_draw_max yes

****** Sizes ******

** Graph size **
grstyle set graphsize 128mm 160mm

**** Size of text elements ****
grstyle set size 4.2  : heading
grstyle set size 3.4  : subheading body
grstyle set size 3.2  : axis_title matrix_label
grstyle set size 3    : key_label 
grstyle set size 2.4  : legend_key_xsize legend_key_ysize
grstyle set size 2.8  : small_body text_option tick_label
grstyle set size 2.5  : minortick_label plabel pboxlabel

grstyle compass2dir key_label north
grstyle horizontal key_gap center

grstyle set color "210 210 210" "140 140 140" "70 70 70" "0 0 0", ///
	intensity(0.8)

**** Size of margins ****
grstyle set margin 3  : graph twoway bygraph 
grstyle set margin 3  : heading
grstyle set margin 1  : subheading

**** Size of plot elements ****
grstyle set symbolsize vsmall: p

grstyle set linewidth none: pie sunflower matrixmark ci_area ci2_area refmarker
grstyle set linewidth vthin: histogram
grstyle set linewidth medium: xyline pbox
grstyle set linewidth medthick: p refline

****** Other settings ******
** Span of text elements **
grstyle yesno title_span no
grstyle yesno subtitle_span no
grstyle yesno caption_span yes
grstyle yesno note_span yes

** Legends **
grstyle clockdir legend_position 6
grstyle areastyle legend none

** Ticks **
grstyle anglestyle vertical_tick horizontal