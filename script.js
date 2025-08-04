document.addEventListener('DOMContentLoaded', function() {
    const projects = document.querySelectorAll('.project');
    
    const tagConfig = {
        author: { icon: 'iconoir-user', tooltip: 'Author' },
        contributor: { icon: 'iconoir-git-merge', tooltip: 'Contributor' },
        tests: { icon: 'iconoir-check-circle', tooltip: 'Has Tests' },
        examples: { icon: 'iconoir-code', tooltip: 'Examples' },
        docs: { icon: 'iconoir-book', tooltip: 'Documentation' },
        active: { icon: 'iconoir-refresh-circle', tooltip: 'Active' }
    };
    
    projects.forEach(project => {
        const projectRole = project.getAttribute('role');
        const projectTags = project.getAttribute('tags');
        const h3 = project.querySelector('h3');
        
        if (!h3) return;
        
        const badgeContainer = document.createElement('span');
        badgeContainer.className = 'project-tags';
        
        if (projectRole && tagConfig[projectRole]) {
            const tag = document.createElement('span');
            tag.className = 'tag';
            
            const icon = document.createElement('i');
            icon.className = tagConfig[projectRole].icon;
            
            const tooltip = document.createElement('span');
            tooltip.className = 'tooltip';
            tooltip.textContent = tagConfig[projectRole].tooltip;
            
            tag.appendChild(icon);
            tag.appendChild(tooltip);
            badgeContainer.appendChild(tag);
        }
        
        if (projectTags) {
            const attrs = projectTags.split(',');
            attrs.forEach(attr => {
                const trimmedAttr = attr.trim();
                if (trimmedAttr && tagConfig[trimmedAttr]) {
                    const tag = document.createElement('span');
                    tag.className = 'tag';
                    
                    const icon = document.createElement('i');
                    icon.className = tagConfig[trimmedAttr].icon;
                    
                    const tooltip = document.createElement('span');
                    tooltip.className = 'tooltip';
                    tooltip.textContent = tagConfig[trimmedAttr].tooltip;
                    
                    tag.appendChild(icon);
                    tag.appendChild(tooltip);
                    badgeContainer.appendChild(tag);
                }
            });
        }
        
        if (badgeContainer.children.length > 0) {
            h3.appendChild(badgeContainer);
        }
    });
});