
float Red_k <

	bool vd_tunable = true;
	float vd_tunablemin = -1.0f;
	float vd_tunablemax = 1.0f;

> = 0.0f;

float Red_cube <

	bool vd_tunable = true;
	float vd_tunablemin = -1.0f;
	float vd_tunablemax = 1.0f;

> = 0.0f;

float Green_k <

	bool vd_tunable = true;
	float vd_tunablemin = -1.0f;
	float vd_tunablemax = 1.0f;

> = 0.0f;

float Green_cube <

	bool vd_tunable = true;
	float vd_tunablemin = -1.0f;
	float vd_tunablemax = 1.0f;

> = 0.0f;

float Blue_k <

	bool vd_tunable = true;
	float vd_tunablemin = -1.0f;
	float vd_tunablemax = 1.0f;

> = 0.0f;

float Blue_cube <

	bool vd_tunable = true;
	float vd_tunablemin = -1.0f;
	float vd_tunablemax = 1.0f;

> = 0.0f;


/*
	Cubic Lens Distortion HLSL Shader
	
	Original Lens Distortion Algorithm from SSontech (Syntheyes)
	http://www.ssontech.com/content/lensalg.htm
	
	r2 = image_aspect*image_aspect*u*u + v*v
	f = 1 + r2*(k + kcube*sqrt(r2))
	u' = f*u
	v' = f*v

	author : François Tarlier
	website : www.francois-tarlier.com/blog/index.php/2009/11/cubic-lens-distortion-shader

*/

texture vd_srctexture; 

sampler src = sampler_state {
	Texture = <vd_srctexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Linear;
	MagFilter = Linear;
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

float4 Distort (sampler smp, float2 uv) {
	
	float crd = (uv.x - 0.5f) * (uv.x - 0.5f) + (uv.y - 0.5f) * (uv.y - 0.5f);

	float RedF = 0.0f;
	float GreenF = 0.0f;
	float BlueF = 0.0f;
	

	if(Red_cube == 0.0f)
	{
		RedF = 1 + crd * Red_k;
	}

	else
	{
		RedF = 1 + crd * (Red_k + Red_cube * sqrt(crd));
	}
	

	if(Green_cube == 0.0f)
	{
		GreenF = 1 + crd * Green_k;
	}


	else
	{
		GreenF = 1 + crd * (Green_k + Green_cube * sqrt(crd));
	}
	

	if(Blue_cube == 0.0f)
	{
		BlueF = 1 + crd * Blue_k;
	}

	else
	{
		BlueF = 1 + crd * (Blue_k + Blue_cube * sqrt(crd));
	}
	
	float2 rDistortion = float2(RedF * (uv.x - 0.5f) + 0.5f, RedF * (uv.y - 0.5f) + 0.5f);
	float2 gDistortion = float2(GreenF * (uv.x - 0.5f) + 0.5f, GreenF * (uv.y - 0.5f) + 0.5f);
	float2 bDistortion = float2(BlueF * (uv.x - 0.5f) + 0.5f, BlueF * (uv.y - 0.5f) + 0.5f);

	float3 distort = float3(0.0, 0.0, 0.0); 

		distort.r = tex2D(smp, rDistortion).r;
		distort.g = tex2D(smp, gDistortion).g;
		distort.b = tex2D(smp, bDistortion).b;

	return float4(distort.r, distort.g, distort.b, 1.0);
}

float4 PS(float2 uv : TEXCOORD0) : COLOR0 {
   
   float4 B = Distort (src, uv);

   return B;
}

technique {

	pass
	{
		VertexShader = compile vs_3_0 VS();
		PixelShader = compile ps_3_0 PS();
	}
}
