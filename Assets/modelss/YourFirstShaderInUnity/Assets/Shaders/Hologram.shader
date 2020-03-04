// shader lab language 
// unlit donot contain light 
Shader "Unlit/Hologram"
{
    Properties
    {
        _MainTex ("Albedo Texture", 2D) = "white" {} //global variables
		_TintColor("Tint Color", Color) = (1,1,1,1)
		
    }
    SubShader // is the actual code that contain sort of instruction for unity about how to set up the render 
    {
        Tags { "RenderType"="Opaque" }
        LOD 100 // Level of Detail we can set the level of detail and change how the shader behaves based on the level of detail

        Pass // single instruction to GPU like say hey draw this we can have multiple shaders in single file
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
           // #pragma multi_compile_fog

            #include "UnityCG.cginc" // this file have whole bunch of rendering function in unity
			// two struct that are going to pass in function
            struct appdata 
            {
                float4 vertex : POSITION; // variable contain for 4 floating values 
                float2 uv : TEXCOORD0;  // bind this 
            };

            struct v2f
            {
                float2 uv : TEXCOORD0; // uv cordinates
               // UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION; // screen space position
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float4 _TintColor;
			// takes the shape of model, potentially modies it
            v2f vert (appdata v) // vertex function 
            {
                v2f o;  // vert to frag 
                o.vertex = UnityObjectToClipPos(v.vertex); // we're taking the vertex from the  model
				// and basically putting it through all those translation into screen space or clip space 
				// UnityObjectToClipPos is function that providing this 
                o.uv = TRANSFORM_TEX(v.uv, _MainTex); 
				// in above we're  taking the uv  data from the model and taking data from the main texture and we're
				// transforming it and this is where 
             //   UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
			// applies color to the shape output by the vert function
			// vert funtion is bound to SV_target which is a render target meaning this is going 
			// to output a render target which in our going to be the frame buffer for the screen
            fixed4 frag (v2f i) : SV_Target  // fragment function 
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) + _TintColor; // color r,g,b,a to draw color pixel
				// tex2D is helper function and is going to read in the color from out main text variable
				// our main text property and uv from data struct
                // apply fog
            //    UNITY_APPLY_FOG(i.fogCoord, col);

                return col;
            }
            ENDCG
        }
    }
}
