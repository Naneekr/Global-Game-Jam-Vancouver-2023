shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec3 HOLY_ORANGE = vec3(1.00, 0.71, 0.14);
uniform float SPEED = 20.0;
uniform vec4 effect_origin = vec4(0.5, 0.5, 1.0, 0);
uniform float RTIME = 0.001;

void fragment() {
	vec2 uvdrop = (UV - effect_origin.xy) * vec2(1.77, 1.0);
	float effect_radius = sqrt(uvdrop.x*uvdrop.x + uvdrop.y*uvdrop.y);
	
	float ripple_time = RTIME - effect_origin.a;
	float ripple_effect = sin(effect_radius*30.0 - ripple_time*SPEED);
	float propagation_distance = ripple_time * SPEED / 30.0;
	float propagation_factor = smoothstep(propagation_distance, propagation_distance - 0.05, effect_radius);
	propagation_factor *= smoothstep(propagation_distance-1.0, propagation_distance, effect_radius);
	propagation_factor /= ripple_time;
	ripple_effect *= propagation_factor;
	//COLOR.rgb = vec3(ripple_effect);
	//COLOR.rg = abs(uvdrop);
	COLOR = textureLod(SCREEN_TEXTURE, UV + normalize(uvdrop)*ripple_effect*0.03, 0);
	COLOR.rgb += HOLY_ORANGE*abs(ripple_effect)*0.5;
}
