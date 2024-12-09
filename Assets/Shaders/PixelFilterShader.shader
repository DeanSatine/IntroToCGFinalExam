Shader "Custom/PixelFilterShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Cull Off
        ZWrite Off
        ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct InputData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct OutputData
            {
                float2 uv : TEXCOORD0;
                float4 position : SV_POSITION;
            };

            OutputData vert(InputData input)
            {
                OutputData output;
                output.position = UnityObjectToClipPos(input.vertex);
                output.uv = input.uv;
                return output;
            }

            sampler2D _MainTex;
            int _PixelDensity;
            float2 _AspectRatioMultiplier;

            fixed4 frag(OutputData input) : SV_Target
            {
                float2 adjustedScaling = _PixelDensity * _AspectRatioMultiplier;
                input.uv = round(input.uv * adjustedScaling) / adjustedScaling;
                return tex2D(_MainTex, input.uv);
            }

            ENDCG
        }
    }
}
