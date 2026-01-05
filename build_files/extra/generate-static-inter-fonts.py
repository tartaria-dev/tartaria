import os
import sys
from fontTools import ttLib
from fontTools.varLib import instancer

# config
INPUT_FILE = "/usr/share/fonts/inter/Inter-Variable.ttf"
OUTPUT_DIR = "/usr/share/fonts/inter-static"
FAMILY_NAME = "Inter Static"

# weight mapping
WEIGHTS = [
    (100, "Thin"),
    (200, "ExtraLight"),
    (300, "Light"),
    (400, "Regular"),
    (500, "Medium"),
    (600, "SemiBold"),
    (700, "Bold"),
    (800, "ExtraBold"),
    (900, "Black"),
]

def patch_names(font, family, subfamily):
    # rewrite internal metadata so OS recognizes fonts as distinct weights
    full_name = f"{family} {subfamily}"
    ps_name = f"{family.replace(' ', '')}-{subfamily}"
    name_table = font['name']
    
    # nameID 1: Family, 2: Subfamily, 4: Full Name, 6: PS Name
    for record in name_table.names:
        if record.nameID == 1:
            record.string = family.encode('utf-16-be')
        elif record.nameID == 2:
            record.string = subfamily.encode('utf-16-be')
        elif record.nameID == 4:
            record.string = full_name.encode('utf-16-be')
        elif record.nameID == 6:
            record.string = ps_name.encode('utf-16-be')

def main():
    # Ensure output directory exists
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    print(f"Loading variable font: {INPUT_FILE}")
    var_font = ttLib.TTFont(INPUT_FILE)

    for w_val, w_name in WEIGHTS:
        output_filename = f"InterStatic-{w_name}.ttf"
        output_path = os.path.join(OUTPUT_DIR, output_filename)
        
        print(f"Instantiating: {w_name} ({w_val})...")
        
        # instantiate static weight
        static_font = instancer.instantiateVariableFont(var_font, {"wght": w_val})
        
        # rewrite metadata
        patch_names(static_font, FAMILY_NAME, w_name)
        
        # save to system path
        static_font.save(output_path)

    os.system("fc-cache -fv")
    print(f"All fonts saved to {OUTPUT_DIR}")

if __name__ == "__main__":
    main()