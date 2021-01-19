import numpy as np

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

def reshape_extend(edep_array):
    '''
    Function that takes in a (1, 64) shaped ndarray to shape it into a square then extend the square along the z-axis
    
    Params
    ------
    edep_array : ndarray of shape (1, 64)
    
    
    Testing
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
    
    if len(edep_array) != 64: raise 'Input array not 64 and can not be reshaped to 8x8'
    square_array = edep_array.reshape(8, 8)
    long_array = np.repeat(square_array[:, :, np.newaxis],  # The array I want to extend by copying along an axis
                           repeats=8, # How many times I want to repeat the square
                           axis=2) # Axis to extend along (begin at 0) axes(0, 1, 2)
    
    return long_array

def calculate_sizes(energy_array):
    '''
    Function that creates an array with linewidth values for plotting. The largest linewidth should be about 5 otherwise they get too big. 
    
    Params
    ------
    energy_array : ndarray This array should be the same array used for the marker color. That way the have the same total amount of elements and the same order.
    
    '''
    
    max_value = energy_array.max()
    
    size_array = energy_array/max_value * 100
    
    return size_array