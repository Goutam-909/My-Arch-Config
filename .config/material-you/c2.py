import subprocess
import json
import os
import sys
import logging
from pathlib import Path

# Set up logging
logging.basicConfig(
    level=logging.DEBUG,
    filename=os.path.expanduser('~/.config/material-you/debug.log'),
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def get_matugen_path():
    """Get the absolute path to matugen executable."""
    cargo_matugen = os.path.expanduser("~/.cargo/bin/matugen")
    if os.path.exists(cargo_matugen):
        return cargo_matugen
    
    try:
        result = subprocess.run(['which', 'matugen'], capture_output=True, text=True)
        if result.returncode == 0:
            return result.stdout.strip()
    except Exception:
        pass
    
    return None

def generate_rgb_conf(json_data):
    """Generate a conf file in the desired rgb format."""
    try:
        conf_content = ""
        
        for theme, colors in json_data['colors'].items():
            for color_name, color_value in colors.items():
                # Replace underscores with hyphens and convert to lowercase
                formatted_name = f"${theme.replace('_', '-')}_{color_name.replace('_', '-').lower()}"
                
                # Extract RGB values and convert them to hex
                r, g, b, a = [round(float(v)) for v in color_value.strip('rgba()').split(',')]
                hex_value = f"{r:02x}{g:02x}{b:02x}"
                
                # Add the formatted line to the conf content
                conf_content += f"{formatted_name} = rgb({hex_value})\n"

        return conf_content
    except Exception as e:
        logging.error(f"Error generating RGB conf: {str(e)}")
        return None

def main(image_path, output_path='~/.config/material-you/colors.conf'):
    logging.info(f"Starting RGB conf generation for image: {image_path}")
    
    output_path = os.path.expanduser(output_path)
    image_path = os.path.abspath(image_path)
    logging.info(f"Full image path: {image_path}")
    logging.info(f"Full output path: {output_path}")
    
    if not os.path.isfile(image_path):
        error_msg = f"Image file not found: {image_path}"
        logging.error(error_msg)
        print(error_msg)
        return

    matugen_path = get_matugen_path()
    if not matugen_path:
        error_msg = "Could not find matugen executable"
        logging.error(error_msg)
        print(error_msg)
        return

    logging.info(f"Using matugen at: {matugen_path}")
    
    env = os.environ.copy()
    cargo_bin = os.path.expanduser("~/.cargo/bin")
    if cargo_bin not in env.get("PATH", ""):
        env["PATH"] = f"{cargo_bin}:{env.get('PATH', '')}"

    try:
        result = subprocess.run(
            [matugen_path, '--json', 'rgba', 'image', image_path],
            capture_output=True,
            text=True,
            env=env,
            check=False
        )

        if result.returncode != 0:
            error_msg = f"Matugen failed with return code {result.returncode}"
            logging.error(error_msg)
            print(error_msg)
            return

        try:
            json_data = json.loads(result.stdout)
        except json.JSONDecodeError as e:
            error_msg = f"Failed to decode JSON: {e}"
            logging.error(error_msg)
            print(error_msg)
            return

        conf_content = generate_rgb_conf(json_data)
        if not conf_content:
            print("Failed to generate conf content. Check the debug log for details.")
            return

        try:
            os.makedirs(os.path.dirname(output_path), exist_ok=True)
        except Exception as e:
            error_msg = f"Failed to create directory: {str(e)}"
            logging.error(error_msg)
            print(error_msg)
            return

        try:
            with open(output_path, 'w') as conf_file:
                conf_file.write(conf_content)
            logging.info("Conf file generated successfully")
            print(f"Conf file generated successfully: {output_path}")
        except Exception as e:
            error_msg = f"Failed to write conf file: {str(e)}"
            logging.error(error_msg)
            print(error_msg)

    except Exception as e:
        error_msg = f"Unexpected error running matugen: {str(e)}"
        logging.error(error_msg)
        print(error_msg)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <image_path>")
        sys.exit(1)
    image_path = sys.argv[1]
    main(image_path)
