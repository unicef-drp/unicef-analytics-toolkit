"""
UNICEF Analytics Toolkit - Python Test Suite
============================================
Tests for Python environment validation
"""

import sys
import pytest


def test_python_version():
    """Test that Python version meets minimum requirements"""
    assert sys.version_info >= (3, 9), \
        f"Python {sys.version_info.major}.{sys.version_info.minor} is below minimum 3.9"


def test_critical_packages_importable():
    """Test that critical packages can be imported"""
    critical_packages = [
        'numpy',
        'pandas',
        'yaml',
        'matplotlib'
    ]
    
    for package in critical_packages:
        try:
            __import__(package)
        except ImportError:
            pytest.fail(f"Critical package '{package}' not importable")


def test_numpy_version():
    """Test numpy version meets requirements"""
    try:
        import numpy as np
        version = tuple(map(int, np.__version__.split('.')[:2]))
        assert version >= (1, 24), \
            f"numpy version {np.__version__} is below minimum 1.24"
    except ImportError:
        pytest.skip("numpy not installed")


def test_pandas_version():
    """Test pandas version meets requirements"""
    try:
        import pandas as pd
        version = tuple(map(int, pd.__version__.split('.')[:2]))
        assert version >= (2, 0), \
            f"pandas version {pd.__version__} is below minimum 2.0"
    except ImportError:
        pytest.skip("pandas not installed")


def test_yaml_functionality():
    """Test YAML package can read/write"""
    try:
        import yaml
        import tempfile
        import os
        
        # Create test data
        test_data = {'test_key': 'test_value', 'test_number': 42}
        
        # Write to temp file
        with tempfile.NamedTemporaryFile(mode='w', suffix='.yml', delete=False) as f:
            yaml.dump(test_data, f)
            temp_file = f.name
        
        # Read back
        with open(temp_file, 'r') as f:
            loaded_data = yaml.safe_load(f)
        
        assert loaded_data == test_data
        
        # Cleanup
        os.unlink(temp_file)
        
    except ImportError:
        pytest.skip("yaml not installed")


def test_pandas_basic_operations():
    """Test pandas basic functionality"""
    try:
        import pandas as pd
        import numpy as np
        
        # Create test DataFrame
        df = pd.DataFrame({'x': range(10), 'y': range(10, 20)})
        
        # Test filtering
        filtered = df[df['x'] > 5]
        assert len(filtered) == 4
        
        # Test aggregation
        mean_val = df['x'].mean()
        assert mean_val == 4.5
        
    except ImportError:
        pytest.skip("pandas not installed")


def test_numpy_basic_operations():
    """Test numpy basic functionality"""
    try:
        import numpy as np
        
        # Create test array
        arr = np.array([1, 2, 3, 4, 5])
        
        # Test operations
        assert np.sum(arr) == 15
        assert np.mean(arr) == 3.0
        assert len(arr) == 5
        
    except ImportError:
        pytest.skip("numpy not installed")
