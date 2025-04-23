import numpy as np
from Astar import find_path
from visualization import visualize_path

# Create a simple grid
grid= np.zeros((20,20)) # 20x20 grid, all free spaces
# Add obstacles
grid[5:15, 10] = 1 # Vertical wall
grid[5, 5:15] = 1 # Horizontal wall
# Define start and goal positions
start_pos = (2,2)
goal_pos = (18,18)

# Find the path
path = find_path(grid, start_pos, goal_pos)

if path:
    print(f"Path found with {len(path)} steps!")
    visualize_path(grid, path)
else:
    print("No path found!")
