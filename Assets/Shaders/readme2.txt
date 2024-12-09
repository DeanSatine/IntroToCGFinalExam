Final Exam Intermediate Comp Graphics
Final Exam for intermediate computer graphics at OTU

Controls:
WASD to move around, mouse to look around. E to disable pixelation, R to enable it G to disable bloom, F to enable it N to make fast moving fire, M to make slow moving fire.

Scene Explination:
A simple scene was based on


My scene look likes the following:

image

Shader Explanations:
Bloom: Bloom is done by progressivly downsampling and upsampling a the textures seen by our camera as a post processing effect. Essentially we progressively downsample and upsample, as well as box sample the textures, then apply them over the original image with a render texture, this render texture is effected by the light of our scene. We also add itterations and soft and hard threshholds to help add control, we also add a color variable to change the color of the sampled and blurred render texture, which can help to add some unique feel to the game. This was implemented in order to add a light to the lava/fire of the object.

Pixelation: Pixelation, at least in the context of this project, is essentially the process of making our screen more pixelated, this done so that the project can have a more retro style and feel. The way this is done is that we change our aspect ratio to increase the density of the pixels within our screen. This allows us to have the pixelated look and feel to our game. A C# script then applies this to our camera which we then use to also correct for the aspect ratio changes, essentially making sure the width and height of our aspect ratio are set to be the correct width and height respectively.

Fire/Lava: Fire/Lava was done by essentially applying a displacement onto a material and changing that displacement to be effected by time within a vertex shader. The following code is used to do this:

void vert(inout appdata_full v) { float displacement = (sqrt(pow(v.vertex.x + _xOffset, 2) + pow(v.vertex.y + _yOffset, 2) + pow(v.vertex.z + _zOffset, 2)) + _TimeShift * (_Time/30)) % 2; if (displacement < 1) { displacement = 0; } else { displacement = 1; } v.vertex.y = displacement * _DisplacementStrength; }

Essentially what this code is, is that based on the different offsets we set within the shader we displace our vertex, based on our displacement, by that amount. I also added the "_Time" functions to do this over a set period of time. Toon Shading was also added. A few other scripts are also involved in order to make the effect. For example a texture shifting C# script was used in order to move the texture over time, which allows us to also move the texture itself and not just the vertex of the object. I also added a simple script to add a moving light, which essentially just increases the range of the light and then decreases it in order to create a flikering effect.

Texturing: For my textures I used some simple original textures created in MSpaint to do so. I then applied toon shading and normal mapping to the object, which helps to add some higher fidelity to the texturs, toon shading is essentially the process of instead of shading linearly, essentially blending the different shades of light together, we instead go from one extreme of shade to another, this is done by basing our light with a "ramp" texture. Normal mapping is the process of adding a normal map to add higher fidelity to the texture, by slightly "bumping" that texture based off the normal of the object.

ToonRampExamTexture