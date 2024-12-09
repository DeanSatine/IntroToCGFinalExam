Shader "Dean/Wave"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (0, 1, 1, 1)
        _MainTex ("Wave Texture", 2D) = "white" {}
        _Freq ("Wave Frequency", Range(0, 5)) = 3
        _Speed ("Wave Speed", Range(0, 10)) = 1
        _Amp ("Wave Amplitude", Range(0, 1)) = 0.1
    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION; // Object-space position
                float2 uv : TEXCOORD0;   // Texture coordinates
            };
            
            struct v2f
            {
                float4 pos : SV_POSITION; // Clip-space position
                float2 uv : TEXCOORD0;    // Pass UVs to fragment shader
            };
            
            // Declare shader properties
            float4 _BaseColor;
            sampler2D _MainTex;
            float _Freq;
            float _Speed;
            float _Amp;
            
            // Vertex Shader
            v2f vert(appdata v)
            {
                v2f o;
                
                // Time-based animation for wave displacement
                float wave = sin(_Time.y * _Speed + v.vertex.x * _Freq) * _Amp;
                
                // Adjust vertex position for wave animation
                float4 displacedPos = v.vertex;
                displacedPos.y += wave;
                
                // Transform position to clip space
                o.pos = UnityObjectToClipPos(displacedPos);
                
                // Pass UVs to fragment shader
                o.uv = v.uv;
                
                return o;
            }
            
            // Fragment Shader
            fixed4 frag(v2f i) : SV_Target
            {
                // Sample texture and apply base color
                fixed4 texColor = tex2D(_MainTex, i.uv);
                return texColor * _BaseColor;
            }
            ENDCG
        }
    }
}


