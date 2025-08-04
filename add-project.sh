#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${BLUE}=== Portfolio Project Entry Generator ===${NC}"
echo

# Read project details
read -p "Project Title: " title
read -p "Project Date (e.g., Jan 2024): " date
read -p "Project Description: " description
read -p "Technologies Used (comma-separated): " technologies
read -p "Project URL (optional, press Enter to skip): " url
read -p "GitHub URL (optional, press Enter to skip): " github

# Ask about project type
echo
echo -e "${YELLOW}Select project type:${NC}"
echo "1) Author (You created this project)"
echo "2) Contributor (You contributed to this project)"
echo "3) None"
read -p "Choice (1-3): " type_choice

# Ask about attributes
echo
echo -e "${YELLOW}Select project attributes (comma-separated numbers):${NC}"
echo "1) tests"
echo "2) examples"
echo "3) docs"
echo "4) active"
read -p "Attributes (e.g., 1,3): " attr_choices

# Build project role attribute
project_role=""
case $type_choice in
    1)
        project_role='role="author"'
        ;;
    2)
        project_role='role="contributor"'
        ;;
esac

# Build tags
tags=""
if [ ! -z "$attr_choices" ]; then
    attr_list=""
    IFS=',' read -ra ATTRS <<< "$attr_choices"
    for attr in "${ATTRS[@]}"; do
        attr=$(echo $attr | xargs) # trim whitespace
        case $attr in
            1)
                attr_list+="tests,"
                ;;
            2)
                attr_list+="examples,"
                ;;
            3)
                attr_list+="docs,"
                ;;
            4)
                attr_list+="active,"
                ;;
        esac
    done
    # Remove trailing comma
    attr_list=${attr_list%,}
    if [ ! -z "$attr_list" ]; then
        tags="tags=\"$attr_list\""
    fi
fi

# Generate the project HTML
project_html="            <div class=\"project\""
if [ ! -z "$project_role" ]; then
    project_html+=" $project_role"
fi
if [ ! -z "$tags" ]; then
    project_html+=" $tags"
fi
project_html+=">
                <h3>$title</h3>
                <p class=\"project-meta\">$date"

# Add links if provided
if [ ! -z "$url" ] || [ ! -z "$github" ]; then
    project_html+=" | "
    if [ ! -z "$url" ]; then
        project_html+="<a href=\"$url\" target=\"_blank\">View Project</a>"
        if [ ! -z "$github" ]; then
            project_html+=" | "
        fi
    fi
    if [ ! -z "$github" ]; then
        project_html+="<a href=\"$github\" target=\"_blank\">GitHub</a>"
    fi
fi

project_html+="</p>
                <p class=\"project-description\">$description</p>
                <p class=\"project-tech\"><strong>Technologies:</strong> $technologies</p>
            </div>"

# Create a backup of the current index.html
cp index.html index.html.bak

# Insert the new project at the beginning of the projects container
# This adds new projects at the top
awk -v project="$project_html" '
    /<div id="projects-container">/ {
        print
        print project
        next
    }
    {print}
' index.html.bak > index.html

echo
echo -e "${GREEN}✓ Project added successfully!${NC}"
echo -e "Backup saved as: index.html.bak"
echo
echo "Preview your portfolio by opening index.html in a web browser."