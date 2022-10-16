# APP ATTRIBUTES ---

## TITLES:
LOGO = 'MDV_logo.png'
TITLE = 'Madsen Data Vis'

## BUSINESS SCIENCE THEME ATTRIBUTES ----
FONT_HEADING  = "Ubuntu"
FONT_BASE = 'Fira Sans'
PRIMARY = '#69bf86'
SECONDARY = '#6978BF'
HIGHLIGHT_FONT = '#d8eedf'
SUCCESS = '#59a843'
INFO = '#0271b8'
WARNING = '#c1d'
DANGER = '#df3131'
FG =  PRIMARY # Foreground
BG = 'white' # Background
#TEXT_OVER_FG = "#BF69A3"
#PLOT_BG = '#7a7671' #Very grey orange colour. A warm grey!

app_lightTheme = bs_theme(
  version = 5,
  font_scale = 1.0,
  heading_font = font_google(FONT_HEADING, wght = c(300, 400, 500, 600, 700, 800), ital = c(0, 1)),
  base_font = font_google(FONT_BASE, wght = c(300, 400, 500, 600, 700, 800), ital = c(0, 1)),
  primary = PRIMARY,
  success = SUCCESS,
  info = INFO,
  warning = WARNING,
  danger = DANGER,
  fg = FG,
  bg = BG,
  'navbar-bg' = PRIMARY,
  'body-color' = PRIMARY,
  'accordion-button-active-bg' = SECONDARY,
  'accordion-button-active-color' = HIGHLIGHT_FONT,
  'bs-accordion-color' = PRIMARY,
  'light' = BG
  # '--bs-accordion-active-color' = TEXT_OVER_FG
  # 'main-svg' = PLOT_BG,  # One half of plotly backgrounds.
  # 'drag' = PLOT_BG #The second half of plotly backgrounds.
)

## DARK VERSIONS ----
FONT_HEADING_d  = "Ubuntu"
FONT_BASE_d = 'Fira Sans'
PRIMARY_d = '#8c95ca' #faint purple
SECONDARY_d = '#8BC9A1'
HIGHLIGHT_FONT_d = '#1d223f'
SUCCESS_d = '#C5E1A5' 
INFO_d = '#0271b8'
WARNING_d = '#c1d'
DANGER_d = '#df3131'
FG_d =  PRIMARY_d # Foreground
BG_d = '#1c1c1c' # Charcoal black
# PLOT_BG = '#7a7671' #Very grey orange colour. A warm grey!

app_darkTheme = bs_theme(
  version = 5,
  font_scale = 1.0,
  heading_font = font_google(FONT_HEADING_d, wght = c(300, 400, 500, 600, 700, 800), ital = c(0, 1)),
  base_font = font_google(FONT_BASE_d, wght = c(300, 400, 500, 600, 700, 800), ital = c(0, 1)),
  primary = PRIMARY_d,
  success = SUCCESS_d,
  info = INFO_d,
  warning = WARNING_d,
  danger = DANGER_d,
  fg = FG_d,
  bg = BG_d,
  'navbar-bg' = PRIMARY_d,
  'body-color' = PRIMARY_d,
  'accordion-button-active-bg' = SECONDARY_d,
  'accordion-button-active-color' = HIGHLIGHT_FONT_d,
  'bs-accordion-color' = PRIMARY_d,
  'light' = BG_d
  # 'main-svg' = PLOT_BG, # One half of plotly backgrounds.
  # 'nsewdrag-drag' = PLOT_BG #The second half of plotly backgrounds.
)

# Other variables!
# bs-body-color (main text)
# bs-accordion-color
# bs-accordion-active-color: text on highlighted accordion tabs.
# bs-accordion-active-bg: the background of highlighted accordion tabs.
# 
# for the top 'Navbar':
#   bs-navbar-active-color: the single activated tab.
# bs-navbar-hover-color: mouse hover over tab.
# bs-navbar-color: Colour of text names of all unselected tabs.
# bs-navbar-brand-color: Colour of dashboard title without hover.
# bs-navbar-brand-hover: Colour of dashboard title with hover.