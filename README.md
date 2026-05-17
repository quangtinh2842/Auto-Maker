<video width="1920" height="1080" controls>
  <source src="[https://example.com/movie.mp4](https://drive.google.com/file/d/1VoY7zqoaRiFAvaUVsbHtSrEQy_2c25UM/view?usp=sharing)" type="video/mp4">
  Your browser does not support the video tag.
</video>

Des: A video editor with less-user interface.

Assets & Example: https://drive.google.com/drive/folders/1WWE6NZPNNinPFNVKgwJHnISOFmzVhsuV?usp=sharing

Funcs:
  - Sound:
      + Start time (on timeline)
      + Trim
      + Adjust volume
      + Fade (fade in & fade out)
  - Video:
      + Layer (for videos group) - This is why the more videos you add, the blurrier it gets
      + Start time (on timeline)
      + Trim
      + Frame (position & size on canvas)
      + Crop
      + // ❌ Corner radius
      + // ❌ Fade (fade in & fade out)
      + // ❌ Bright (bright in & bright out)
      + // ❌ Shadow
      + // ❌ Rotate
      + // ❌ Adjust color (exposure, contrast, saturation, temperature, transparency, negative)
      + // ❌ Filters (contrast, white, black, yellow, orange, red, pink, purple, blue, turquoise, green, black and white)
      + // ❌ Effects (flash, shake, pulse, greenscreening, slow zoom, spin, rotation, blur, disco, color shift)
  - Image:
      + Layer
      + Start time (on timeline)
      + Duration (life duration on timeline)
      + Frame (position & size on canvas)
      + Crop
      + Background color
      + Corner radius
      + Border width
      + Border color
      + Fade (fade in & fade out)
      + // ❌ Bright (bright in & bright out)
      + Shadow
      + Rotate
      + Adjust color (exposure, contrast, saturation, temperature, transparency, negative)
      + Filters (contrast, white, black, yellow, orange, red, pink, purple, blue, turquoise, green, black and white)
      + Effects (flash, shake, pulse, greenscreening, slow zoom, spin, rotation, blur, disco, color shift)
  - Text:
      + Layer
      + Start time (on timeline)
      + Duration (life duration on timeline)
      + Frame (position & size on canvas)
      + String
      + Font
      + Foreground color
      + Stroke width
      + Stroke color
      + Background color
      + Corner radius
      + Border width
      + Border color
      + Fade (fade in & fade out)
      + // ❌ Bright (bright in & bright out)
      + Shadow
      + Rotate
      + Adjust color (exposure, contrast, saturation, temperature, transparency, negative)
      + Filters (contrast, white, black, yellow, orange, red, pink, purple, blue, turquoise, green, black and white)
      + Effects (flash, shake, pulse, greenscreening, slow zoom, spin, rotation, blur, disco, color shift)
   
Weakness: The more videos, the lower the resolution (just apply for video layers (maybe))

OS: macOS (the tech I need which was not supported on iOS yet)

Frameworks: Cocoa, AVFoundation, CoreImage

Additional: You need to install two fonts (Roboto-Medium.ttf & Roboto-Light.ttf)
