//-----------------------------------------------------------------------------
// Global variables
//-----------------------------------------------------------------------------

// World matrix and combined view / projection matrix
float4x3 WorldMatrix    : WORLD;
float4x4 ViewProjMatrix : VIEWPROJECTION;
float3 CameraPosition   : CAMERAPOSITION;



//-----------------------------------------------------------------------------
// Input / output structures
//-----------------------------------------------------------------------------

// Input to Vertex Shader
struct VS_Input
{
	float3 Position : POSITION;
	float3 Normal : NORMAL;
	float2 TexCoord0 : TEXCOORD0;
};

// Output from Vertex Shader
struct VS_Output
{
	float4 Position : POSITION;
	float3 DiffuseColour : COLOR0;
	float3 SpecularColour : COLOR1;
	float2 TexCoord0 : TEXCOORD0;
};

//-----------------------------------------------------------------------------
// Main function
//-----------------------------------------------------------------------------

// Main vertex shader function
void main( in VS_Input i, out VS_Output o )
{

	// I HAVE NO IDEA WHAT IM DOING
	// KINDA

	// Can change colour + intensity of light
	const float3 AmbientColour = { 0.3f, 0.3f, 0.3f };
	const float3 LightColour = { 1.0f, 1.0f, 1.0f };

	// Probably changes position of light source + intensity
	const float3 DirToLight = { 0, 0, 5.0 };
	const float SpecularPower = 5.0f;

    // Transform model vertex position to world space, then to viewport space, then output it
    float3 WorldPosition = mul( float4(i.Position, 1.0f), WorldMatrix );
    o.Position = mul( float4(WorldPosition, 1.0f), ViewProjMatrix );

	// Calculate normal (some important thing)
	float3 Normal = normalize( mul( float4(i.Normal, 0.0f), WorldMatrix ) ).xyz;

	// Usually calculates diffuse colour
	//float3 DiffuseColour = AmbientColour + LightColour * saturate( dot( Normal, DirToLight ) );
    //o.DiffuseColour = float4( DiffuseColour, 1.0f );

	float3 DirToCamera = normalize( CameraPosition - WorldPosition );
	float3 H = normalize( DirToCamera + DirToLight );
	// Replace diffuse colour with specular
	o.DiffuseColour = LightColour * pow( saturate( dot(Normal, H) ), SpecularPower ); // Phong

	o.TexCoord0 = i.TexCoord0;
}
