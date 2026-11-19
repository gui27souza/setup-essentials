// url: https://www.shadertoy.com/view/ldccW4
// credits: WillKirkby
// @texture0 Resources/Font_Set.png
// @texture1 Resources/Shadertoy_RGBA_Noise_Small.png

#define CELL_SIZE 16.0
#define FALL_SPEED 0.1
#define FLICKER_SPEED 0.00001
#define TRAIL_LENGTH 20.0
#define RAIN_COLOR vec3(1, 1.0, 1)

float text(vec2 fragCoord)
{
    vec2 uv = mod(fragCoord.xy, CELL_SIZE) / CELL_SIZE;
    vec2 block = (fragCoord / CELL_SIZE) - uv;
    uv = uv * .8 + .1;
    uv += floor(texture(iChannel1, block / iChannelResolution[1].xy + iTime * FLICKER_SPEED).xy * 16.);
    uv *= .0625;
    uv.x = -uv.x;
    return texture(iChannel0, uv).r;
}

vec3 rain(vec2 fragCoord)
{
    fragCoord.x -= mod(fragCoord.x, CELL_SIZE);
    fragCoord.y -= mod(fragCoord.y, CELL_SIZE);

    float offset = sin(fragCoord.x * 15.);
    float speed = cos(fragCoord.x * 3.) * .3 + .7;

    float y = fract(fragCoord.y / iResolution.y + (iTime * FALL_SPEED) * speed + offset);
    return RAIN_COLOR / (y * TRAIL_LENGTH);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    fragColor = vec4(text(fragCoord) * rain(fragCoord), 1.0);
}
