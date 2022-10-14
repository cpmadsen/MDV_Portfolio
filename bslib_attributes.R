# APP ATTRIBUTES ---

## TITLES:
LOGO = 'MDV_logo.png'
TITLE = 'Madsen Data Vis'

## BUSINESS SCIENCE THEME ATTRIBUTES ----
FONT_HEADING  = "Ubuntu"
FONT_BASE = 'Fira Sans'
PRIMARY = '#2daee0'
SUCCESS = '#2fbb00'
INFO = '#0271b8'
WARNING = '#c1d'
DANGER = '#df3131'
FG =  PRIMARY # Foreground
BG = 'white' # Background

app_lighttTheme = bs_theme(
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
  'accordion-button-active-bg' = SUCCESS,
  'accordion-button-active-color' = PRIMARY,
  'bs-accordion-color' = PRIMARY,
  'light' = BG
)

## DARK VERSIONS ----
FONT_HEADING_d  = "Ubuntu"
FONT_BASE_d = 'Fira Sans'
PRIMARY_d = '#2daee0'
SUCCESS_d = '#2fbb00'
INFO_d = '#0271b8'
WARNING_d = '#c1d'
DANGER_d = '#df3131'
FG_d =  PRIMARY_d # Foreground
BG_d = 'black' # Background

app_darkTheme = bs_theme(
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
  'accordion-button-active-bg' = SUCCESS_d,
  'accordion-button-active-color' = PRIMARY_d,
  'bs-accordion-color' = PRIMARY_d,
  'light' = BG_d
)