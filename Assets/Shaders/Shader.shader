Shader "Unlit/Shader" {
    Properties // input data
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _ColorStart ("Color Start", Range(0,1)) = 0
        _ColorEnd ("Color End", Range(0,1)) = 1
    }
    SubShader {
        Tags { "RenderType"="Opaque" }

        Pass {

            Blend One One // additive
            // Blend DstColor Zero // multiply

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU 6.28318530718

            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;


            struct MeshData { // per-vertex mesh data 
                float4 vertex : POSITION; // vertex position
                float3 normals : NORMAL; // local space normal direction
                // float4 tangent : TANGENT; // tangent direction (xyz) tangent sign (w)
                // float4 color : COLOR; // vertex color
                float2 uv0 : TEXCOORD0; // uv0 diffuse/normal map textures
                //float2 uv1 : TEXCOORD1; // uv1 coordinates lightmap coordinates
                //float2 uv2 : TEXCOORD2; // uv2 coordinates lightmap coordinates
                //float2 uv3 : TEXCOORD3; // uv3 coordinates lightmap coordinates
            };

            // data passed from the vertex shader to the fragment shader
            // this will interpolate/blend across the triangle
            struct Interpolators {
                float4 vertex : SV_POSITION; // clip space position
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            Interpolators vert (MeshData v) {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); // local space to clip
                o.normal = UnityObjectToWorldNormal (v.normals); // just pass through
                o.uv = v.uv0; // pass through
                return o;
            }

            float InverseLerp(float a, float b, float v) {
                return (v-a)/(b-a);
            }

            fixed4 frag (Interpolators i) : SV_Target {
                // float t = saturate (InverseLerp( _ColorStart, _ColorEnd, i.uv.x) );  
                // float t = abs(frac(i.uv.x * 5) * 2 - 1);

                

                float xOffset = cos( i.uv.x * TAU * 8 ) * 0.01 ;

                float t = cos( ( i.uv.y + xOffset - _Time.y * 0.1 ) * TAU * 5) * 0.5 + 0.5;

                t *= 1-i.uv.y;




                return t;
                // float4 outColor = lerp( _ColorA, _ColorB, t);
                // return outColor;

                // blend between two colors bads on the X UV coordinate
                // float4 outColor = lerp( _ColorA, _ColorB, i.uv.x);
                // return outColor;
            }

            ENDCG
        }
    }
}
