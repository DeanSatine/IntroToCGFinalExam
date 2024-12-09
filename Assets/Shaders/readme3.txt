All Shaders and Scripts taken from slides or tutorial content.

Textures are my own except for Base neutral LUT, taken from here: https://drive.google.com/file/d/1GK0r5-mHSXhab8S7UZe4MB9gskkluhrt/view.

All other LUT files are edited from Base neutral LUT.

Light Rotation script is taken from Unity Manual: https://docs.unity3d.com/ScriptReference/Transform.RotateAround.html

Where to find code: You can find code in: Where to find code

Code explinations:

Toon Ramp shader: Added Toon Ramp shader onto the main plane, but not the cock pit, as well as adding it onto the cloud background. I also added reverse rim lighting onto the object. Toon Ramp works by instead of blending colors, it takes color values, and instead of blending those values, essentially clamps certain light to the toon ramp texture I have created. In this case I also used a different ramp texture then usual, as the lighting on the object shown to us in the example is slightly lighter. For the reverse rimlighting, I essentially reversed the colors on the emmission of my object to add a very small black outline to the object, this is too give that slightly "cartoonish" look given to us in the limit. Rim lighting works by taking in the dot product of our view direction and our normal, by focusing more lighting onto the edges of our object based on the viewdir and the normal.

In a basic pseudo code:

        float diff = dot(s.Normal, lightDir);
        float h = diff * 0.5 + 0.5;
        float2 rh = h;
        float3 ramp = tex2D(_RampTex, rh).rgb;

        float4 t;
        t.rgb = s.Albedo * _LightColor0.rgb * (ramp);
        t.a = s.Alpha;
        return t;
// this code sets up the toon ramp, essentially float h is what clamps light values onto the ramp texture

void surf (Input IN, inout SurfaceOutput o) { half4 c = tex2D(_MainTex, IN.uv_MainTex); o.Albedo = c.rgb; o.Alpha = c.a; half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal)); o.Emission = 0.1 - _RimColor.rgb * pow(rim, _RimPower);

    }
// this code here is where I set my main texture up, o.Emisson as you can see is subtracted from a value of 0.1, this gives us a reverse color palette to the one we already have

Cock Pit reflection shader:

In this shader I used specular physically based rendering in order to create the cock pit reflection. Physically based rendering is made up of a few components, such as:

Smoothness Metallicity Conversion of Energy Diffuse Fresnel Reflectivity Transparency

I also added rim lighting to intensify the lighting of the reflection on the edges, which is what fresnel reflectivity is.

pseudo code:

    void surf(Input IN, inout SurfaceOutputStandardSpecular o)
    {
        o.Albedo = _Color.rgb;
        o.Smoothness = tex2D(_MetallicTex, IN.uv_MetallicTex).r;
        o.Specular = _SpecColor.rgb;
        half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
        o.Emission = _RimColor.rgb * pow(rim, _RimPower) * 10;

    }
You can also find the builds in the build folder of the project.