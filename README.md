# dbcollection for Matlab

[![Build Status](https://travis-ci.org/dbcollection/dbcollection-matlab.svg?branch=master)](https://travis-ci.org/dbcollection/dbcollection-matlab)

This is a simple Matlab wrapper for the Python's [dbcollection](https://github.com/dbcollection/dbcollection) module. The functionality is almost the same, appart from some few minor differences related to Lua, namely regarding setting up ranges when fetching data.

Internally it calls the Python's dbcollection module for data download/process/management. The, Matlab interacts solely with the metadata `hdf5` file to fetch data from disk.


## Package installation

## Requirements

This package requires:

- dbcollection (Python).
- Matlab >= 2014a or octave >= 4.0.0
- [JSONlab](https://github.com/fangq/jsonlab)

> Note: This code may work on other previous versions of Matlab but, since it was developed and tested only on Matlab 2014a and octave >= 4.0.0, I cannot provide any garantees concerning older version compatabilities.


### Installation

To install the dbcollection's Matlab API you must first have the Python's version installed in your system. If you do not have it already installed, then you can install it either via `pip`, `conda` or from [source](https://github.com/dbcollection/dbcollection#package-installation). Here we'll use `pip` to install this package:

```bash
$ pip install dbcollection
```

After you have the Python's version installed in your system, get the Matlab's API via the following repository:

```bash
$ git clone https://github.com/dbcollection/dbcollection-matlab
```

Then, add `dbcollection-matlab/` to your Matlab's path:

```matlab
addpath('<path>/dbcollection-matlab/');
```


Also, this package requires the [JSONlab](https://github.com/fangq/jsonlab) json encoder/decoder to work. To install this package just download the repo to disk:

```bash
$ git clone https://github.com/fangq/jsonlab
```

and add it your Matlab's path:

```matlab
addpath('/path/to/jsonlab');
```


## Getting started

### Usage

This package follows the same API as the Python version. Once installed, to use the package simply call the class *dbcollection*:

```matlab
dbc = dbcollection();
```

Then, just like in Python, to load a dataset you simply do:

```matlab
mnist = dbc.load('mnist');
```

You can also select a specific task for any dataset by using the `task` option.

```matlab
mnist = dbc.load(struct('name', 'mnist', 'task', 'classification'));
```

This API lets you download+extract most dataset's data directly from its source to the disk. For that, you can use the `download()` method to fetch data online from the dataset's source repository:

```matlab
dbc.download(struct('name', 'cifar10', 'data_dir', 'some/dir/path'));
```

### Data fetching

Once a dataset has been loaded, in order to retrieve data
you can either use Matlab's `HDF5` API or use the provided
methods to retrive data from the .h5 metadata file.

For example, to retrieve an image and its label from the `MNIST` dataset using the Matlab's `HDF5` API you can do the following:

```matlab
imgs = h5read(mnist.cache_path, 'default/train/images');  % fetch data
imgs = permute(imgs, ndims(imgs):-1:1);  % permute dimensions to the original format
img = imgs(1,:,:,:);  % slice array

labels = h5read(mnist.cache_path, 'default/train/labels');  % fetch data
labels = permute(labels, ndims(labels):-1:1);  % permute dimensions to the original format
label = labels(1,:);  % slice array
```

or you can use the API provided by this package:

```matlab
img = mnist.get('train', 'images', 1)
label = mnist.get('train', 'labels', 1)
```


## Documentation

For a more detailed view of the Matlab's API documentation see [here](DOCUMENTATION.md#db.documentation).


## License

[MIT license](LICESNE)
