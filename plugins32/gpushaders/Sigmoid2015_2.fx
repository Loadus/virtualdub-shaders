
float Curve_R <
	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 10.0f;
> = 3.0f;

float Curve_G <
	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 10.0f;
> = 3.0f;

float Curve_B <
	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 10.0f;
> = 3.0f;

float Gamma_R <
	bool vd_tunable = true;
	float vd_tunablemin = 0.45f;
	float vd_tunablemax = 2.2f;
> = 1.0f;

float Gamma_G <
	bool vd_tunable = true;
	float vd_tunablemin = 0.45f;
	float vd_tunablemax = 2.2f;
> = 1.0f;

float Gamma_B <
	bool vd_tunable = true;
	float vd_tunablemin = 0.45f;
	float vd_tunablemax = 2.2f;
> = 1.0f;

texture vd_srctexture;

sampler src = sampler_state {
	Texture = <vd_srctexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};

void VS (float4 pos : POSITION,	
 		 float2 t0 : TEXCOORD0,
		 out float4 oPos : POSITION, 
		 out float2 oT0 : TEXCOORD0)
{
	oPos = pos;
	oT0 = t0;
}

float SCurve (float value, float amount, float correction) {

	float curve = 1.0; 

	value = pow(value, 0.45); 

    if (value < 0.5)
    {

        curve = pow(value, amount) * pow(2.0, amount) * 0.5; 
    }
        
    else
    { 	
    	curve = 1.0 - pow(1.0 - value, amount) * pow(2.0, amount) * 0.5; 
    }

    return pow(pow(curve, 2.2), correction);
}

float4 main (float2 uv : TEXCOORD0) : COLOR0 {
   
   float4 B = tex2D(src, uv);

   		B.r = SCurve(B.r, Curve_R, Gamma_R);
   		B.g = SCurve(B.g, Curve_G, Gamma_G);
   		B.b = SCurve(B.b, Curve_B, Gamma_B);

   return B;
}

technique {
	pass {

		VertexShader = compile vs_3_0 VS();
		PixelShader = compile ps_3_0 main ();
	}
}
