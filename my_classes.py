import numpy as np
import os
import pandas as pd

#=========================================================================
def create_3d_cords():
    '''
    This creates a set of coordinate pairs along the 3D 8x8x8 grid
    
    Returns
    -------
    coordinates : tuple of ndarrays
    (x_cords, y_cords, z_cords)
    '''
    
    x = np.arange(1, 9)
    y = np.arange(1, 9)
    z = np.arange(1, 9)
    
    x_cords, y_cords, z_cords = np.meshgrid(x, y, z)
    
    return x_cords, y_cords, z_cords

#=========================================================================

def reshape_extend(edep_array):
    '''
    Function that takes in a (1, 64) shaped ndarray to shape it into a square then extend the square along the z-axis
    
    Params
    ------
    edep_array : ndarray of shape (1, 64)
    
    
    Example
    -------
    Run this code to make a square with the middle of one color then feed it into the function 
    
    colors = np.ones((8, 8))
    colors[5, 2:6] = 0 # 
    colors = colors.flatten()
    colors = reshape_extend(colors)
    colors.shape

    x, y, z = np.meshgrid(np.arange(1, 9), np.arange(1, 9), np.arange(1, 9))
    fig = plt.figure()
    ax = plt.subplot(111, projection='3d')
    ax.scatter(x, y, z, c=colors)
    ax.set_xlabel('x axis')
    '''
    
    square_array = edep_array.reshape(8, 8)
    long_array = np.repeat(square_array[:, :, np.newaxis],  # The array I want to extend by copying along an axis
                           repeats=8, # How many times I want to repeat the square
                           axis=2) # Axis to extend along (begin at 0) axes(0, 1, 2)
    return long_array

#=========================================================================

def calculate_sizes(energy_array):
    '''
    Function that creates an array with linewidth values for plotting. The largest linewidth should be about 5 otherwise they get too big.
    Normalizes the data to the range [0, 1] then multiplies by 100 for the end size
    
    Params
    ------
    energy_array : ndarray This array should be the same array used for the marker color. 
    That way the have the same total amount of elements and the same order.
    '''
    
    max_value = energy_array.max()
    
    size_array = energy_array/max_value * 100
    
    return size_array

#=========================================================================

def bar_chart_helper(bar_heights):
    '''
    Helper function to build all of the accessory stuff when if comes to makeing 3d bar charts.
    Rotates the data so that channel 1 is at the top left and channel 8 at the top right.
    
    Params
    ------
    bar_heights : ndarray of dim(1, 64) This array is the data you want plotted with the height. 
    It ensures it is able to be wrapped into 8x8
    
    Returns
    ------
    x : [array] Array containing the x starting position of  each bar
    y : [array] Array containing the y starting position of each bar
    bottom : [array] Array containing the z starting position of each bar
    width : [scalar] The thickness of each bar in the x direction, is set to 1 unit
    depth : [scalar] The thickness of each bar in the x direction, is set to 1 unit
    height : [array] Array of the height of each bar. The heights are from the parameter bar_heights
    
    Example
    ------
    
    Example from https://matplotlib.org/3.1.1/gallery/mplot3d/3d_bars.html
    
    import numpy as np
    import matplotlib.pyplot as plt
    # This import registers the 3D projection, but is otherwise unused.
    from mpl_toolkits.mplot3d import Axes3D  # noqa: F401 unused import


    # setup the figure and axes
    fig = plt.figure(figsize=(8, 3))
    ax1 = fig.add_subplot(121, projection='3d')
    ax2 = fig.add_subplot(122, projection='3d')

    # fake data
    _x = np.arange(4)
    _y = np.arange(5)
    _xx, _yy = np.meshgrid(_x, _y)
    x, y = _xx.ravel(), _yy.ravel()

    top = x + y
    bottom = np.zeros_like(top)
    width = depth = 1

    ax1.bar3d(x, y, bottom, width, depth, top, shade=True)
    ax1.set_title('Shaded')

    ax2.bar3d(x, y, bottom, width, depth, top, shade=False)
    ax2.set_title('Not Shaded')

    plt.show()
    '''
    
    _x, _y = np.arange(8), np.arange(8)
    _xx, _yy = np.meshgrid(_x, _y, indexing='ij') # meshgrid creates a grid of coordinates with the desired x and y dimensions
    x, y = _xx.ravel(), _yy.ravel() # ravel just flattens the ndim array into 1dim
    
    z = np.zeros_like(bar_heights)
    width = depth = 1
    
    rotated_data = bar_heights
    return x, y, z, width, depth, rotated_data.flatten()

#=========================================================================

def load_data_ohio(ohio_extraction_dir='/home/gmf/Projects/dosimeter/ohio_data/extracted_data/'):
    '''
    A convenience function that will create a dictionary containing the energy deposition of each run.
    
    Params
    ------
    ohio_extraction_dir : [str] The path to the ohio_data extraction directory
    
    Return
    ------
    energy_dict : [dictionary]
        key : [str filename] The name of the file holding the data
        value : [ndarray] dim(1, 64) Energy deposited in each pixel
    '''
    
    extracted_dir = ohio_extraction_dir
    
    # Creates a list of file paths of only txt files and not run 22
    files = sorted([os.path.join(extracted_dir, file) for file in os.listdir(extracted_dir) 
                    if all((file.endswith('txt'), '22' not in file))])

    energy_dict = {}
    for file in files:
        df = pd.read_csv(file, delim_whitespace=True, header=2)
        file_name = os.path.basename(file)
        data_array = np.array(df['edep'])
        energy_dict[file_name] = data_array
    return energy_dict

#=========================================================================

def load_data_geant(geant_extraction_dir):
    '''
    A convenience function that will create a dictionary containing the energy deposition of each run.
    
    Params
    ------
    geant_extraction_dir : [str] The path to the ohio_data extraction directory
    
    Return
    ------
    energy_dict : [dictionary]
        key : [str filename] The name of the file holding the data
        value : [ndarray] dim(1, 64) Energy deposited in each pixel
    '''
    
    extracted_dir = geant_extraction_dir
    
    # Creates a list of file paths of only txt files and not run 22
    files = sorted([os.path.join(extracted_dir, file) for file in os.listdir(extracted_dir) 
                    if all((file.endswith('txt'), '22' not in file))])

    energy_dict = {}
    for file in files:
        df = pd.read_csv(file, delim_whitespace=True, header=0)
        file_name = os.path.basename(file)
        data_array = np.array(df['edep'])
        energy_dict[file_name] = data_array
    return energy_dict

#=========================================================================

def bar_chart_helper_rot(bar_heights):
    '''
    This function does the same thing as the normal bar_chart_helper but will plot bars horizontally
    by changing x, y, z, dx, dy, dz
    
    the dy is contains the length of the bars
    
    they start at different y and z but all the same x
    '''
    _y, _z = np.arange(8), np.flip(np.arange(8))
    _yy, _zz = np.meshgrid(_y, _z, indexing='xy') # This took a little while for me to understand why this works but buy default, the grid will do all of the y then z as if it were moving up a level, I want it to move z then down a y
    y, z = _yy.ravel(), _zz.ravel() # ravel just flattens the ndim array into 1dim

    x = np.zeros_like(y)
    dy = dz = 1

    rotated_data = bar_heights #np.rot90(bar_heights.reshape((8, 8)), axes=(0, 1)).flatten() # This rotates the data by 90 degrees so that channel 1 is in the top left corner and channel 8 in the top right.
    return x, y, z, rotated_data, dy, dz

#=========================================================================

def load_gate_data_by_angle(extracted_dir = '/home/gmf/Projects/dosimeter/geant_data/extracted_data/grant_gate/'):
    '''Function that will parse all of the extracted run names and generate a dictionary of all of the run width and height combinations. This
    will allow me to plug in a width and height that I want and get all of the angles of with the beam of that size'''
    
    
    # Generating the large list of all the paths
    paths = sorted([os.path.join(extracted_dir, file) for file in os.listdir(extracted_dir)
               if file.endswith('.txt')])

    # Generates a dictionary seperating out the files based on beam size
    size_dict = {}
    for width in range(5, 51, 5):
        for height in range(5, 51, 5):
            w_pattern = str(width).zfill(2)
            h_pattern = str(height).zfill(2)
            angle_list = [path for path in paths 
                         if all((f'W{w_pattern}' in path, f'H{h_pattern}' in path))]
            size_dict[f'W{w_pattern}_H{h_pattern}'] = angle_list
            
    # Generates a dictionary that will contain a dictionary mapping the angle to the edep
    size_energy_dict = {}
    for beam_size, file_list in size_dict.items():
        edep_dict = {}
        for file in file_list:
            file_name = os.path.basename(file)
            df = pd.read_csv(file, delim_whitespace=True)
            edep = np.array(df['edep'])
            edep_dict[file_name] = edep
        size_energy_dict[beam_size] = edep_dict
    return size_energy_dict