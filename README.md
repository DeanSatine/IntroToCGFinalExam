# IntroToCGFinalExam

# Controls: Left & Right arrow keys to move the player, tick the CameraMove script in the inspector to move freely around the scene.

My scene looks like this: 

![image](https://github.com/user-attachments/assets/ab4c1ce3-7b2a-4140-898f-69488f6f0e4b)

# Shader Explanations:

Wave: Added to the enemy Goombas to give them feel more alive and animated, along with the Yoshi head. This shader animates a wave effect by modifying vertex positions vertically based on a sine wave function. The wave's behavior is controlled using adjustable properties: frequency, speed, and amplitude. The fragment shader applies a texture and a base color.

Toon w/ Ramping & Outline: Toon shader added to the Yoshi & Coins. It works by instead blending colours to then take color values to then clamp light to the textures.

Scrolling: For the background and floor to make it seem like the environment is constantly moving, to make it feel fasst paced. The surf function scrolls both textures over time using the _ScrollX and _ScrollY values. The foam texture scrolls at half the speed of the main texture for variation which then combines the water and foam textures and calculates the final color by averaging them, producing a moving water surface with foam details, blending both textures dynamically over time.

Colour Grading: Renders without depth testing or culling to then define a single render pass using a vertex and fragment shader.
The vertex Shader then passes UV coordinates and transforms vertex positions for rendering. Then samples the original texture color and computes LUT coordinates based on the color values. Applies color grading by sampling the LUT using the computed position. Finally, blends the original color with the graded color based on _Contribution.

Pixel Filter: The filter was added to make the game fit the retro aesthetic, this is done by changing aspect ratio to make every pixel more dense across the screen, scrunching it and giving it that dense pixel look.


# Diagram:

![image](https://github.com/user-attachments/assets/3c747b47-0dba-403c-b3c0-659acdb94b11)



# Steps

Started with building the scene and choosing appropriate shaders to use on the scene. Scrolling textures were chosen for the environment to fit the fast paced gameplay, then adding toon shaders on top of the environment in order to make it look cartoony. I then created a pixel filter to make the game retro like as it initially was, to then finalize with recrating 1:1 the UI and placements as best I could. All techniques and steps to do these things have been explained previously.

# Sources: 

Yoshi Texture: https://www.istockphoto.com/photos/green-wool-texture

Coin: https://www.pngkey.com/maxpic/u2w7r5r5o0w7o0w7/

Background/Scrolling Texture: https://www.artstation.com/artwork/R3YaAr

Grass: https://www.everypixel.com/image-280823971340566868
