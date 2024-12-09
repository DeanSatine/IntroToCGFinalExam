Shader "Lighting" {
    Properties {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}  
        _Gain("Lightmap tone-mapping Gain", Float) = 1  
        _Knee("Lightmap tone-mapping Knee", Float) = 0.5  
        _Compress("Lightmap tone-mapping Compress", Float) = 0.33 
    }
    
    SubShader {
        Tags { "RenderType"="Opaque" }
        
        CGPROGRAM
        // Declare the surface shader with a custom lighting function
        #pragma surface surf StandardToneMappedGI
        
        // Include Unity's physically-based lighting models
        #include "UnityPBSLighting.cginc"
        
        half _Gain; 
        half _Knee;  
        half _Compress; 
        sampler2D _MainTex; 

        inline half3 TonemapLight(half3 i) {
            i *= _Gain;  // Multiply input intensity by the gain value
            // Apply compression only if intensity exceeds knee value
            return (i > _Knee) ? (((i - _Knee) * _Compress) + _Knee) : i;
        }

        inline half4 LightingStandardToneMappedGI(SurfaceOutputStandard s, half3 viewDir, UnityGI gi)
        {
            return LightingStandard(s, viewDir, gi);  
        }

        // Modify global illumination (GI) data with tone-mapping
        inline void LightingStandardToneMappedGI_GI(
            SurfaceOutputStandard s,
            UnityGIInput data,
            inout UnityGI gi)
        {
            LightingStandard_GI(s, data, gi);  // Call Unity's GI calculation

            // Apply tone-mapping to direct light in the GI pass
            gi.light.color = TonemapLight(gi.light.color);
            
            // Handle directional lightmaps (for baked and dynamic lightmaps)
            #ifdef DIRLIGHTMAP_SEPARATE
                #ifdef LIGHTMAP_ON
                    gi.light2.color = TonemapLight(gi.light2.color);  // Apply tone-mapping to baked lightmap
                #endif
                #ifdef DYNAMICLIGHTMAP_ON
                    gi.light3.color = TonemapLight(gi.light3.color);  // Apply tone-mapping to dynamic lightmap
                #endif
            #endif
            
            // Apply tone-mapping to indirect lighting (diffuse and specular)
            gi.indirect.diffuse = TonemapLight(gi.indirect.diffuse);
            gi.indirect.specular = TonemapLight(gi.indirect.specular);
        }

        // Input structure to handle texture coordinates
        struct Input {
            float2 uv_MainTex;  // Texture coordinates for the main texture
        };

        // Surface function to define the material properties
        void surf (Input IN, inout SurfaceOutputStandard o) {
            // Sample the albedo texture and assign it to the surface's Albedo property
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
        }
        
        ENDCG
    }
    
    // Fallback shader if this shader cannot be supported
    FallBack "Diffuse"
}
