"""
UNICEF Analytics Toolkit - Environment Validation Tests
=======================================================
Tests for environment configuration and paths
"""

import os
import sys
import pytest
from pathlib import Path


def test_project_root_exists():
    """Test that we can identify project root"""
    # Assuming tests are in tests/python/
    current_file = Path(__file__)
    project_root = current_file.parent.parent.parent
    
    assert project_root.exists()
    assert project_root.is_dir()


def test_requirements_files_exist():
    """Test that requirements files exist in project root"""
    current_file = Path(__file__)
    project_root = current_file.parent.parent.parent
    
    requirements_files = [
        'requirements-python.txt',
        'requirements-r.txt',
        'requirements-stata.do'
    ]
    
    for req_file in requirements_files:
        req_path = project_root / req_file
        assert req_path.exists(), f"{req_file} should exist in project root"


def test_readme_exists():
    """Test that README exists and is readable"""
    current_file = Path(__file__)
    project_root = current_file.parent.parent.parent
    
    readme = project_root / 'README.md'
    assert readme.exists()
    
    # Try to read it
    # Force UTF-8 to avoid Windows codepage errors
    content = readme.read_text(encoding="utf-8")
    assert len(content) > 0
    assert 'UNICEF' in content


def test_config_templates_exist():
    """Test that configuration templates exist"""
    current_file = Path(__file__)
    project_root = current_file.parent.parent.parent
    
    config_dir = project_root / '_config_template'
    assert config_dir.exists(), "_config_template directory should exist"
    
    templates = [
        'user_config.yml',
        'project_config.yml',
        'profile_SIMPLE.R'
    ]
    
    for template in templates:
        template_path = config_dir / template
        assert template_path.exists(), f"Template {template} should exist"


def test_logs_directory_writable():
    """Test that logs directory can be created and is writable"""
    current_file = Path(__file__)
    project_root = current_file.parent.parent.parent
    
    logs_dir = project_root / 'logs'
    logs_dir.mkdir(exist_ok=True)
    
    assert logs_dir.exists()
    assert logs_dir.is_dir()
    
    # Test write permissions
    test_file = logs_dir / 'test.txt'
    test_file.write_text('test')
    assert test_file.exists()
    
    # Cleanup
    test_file.unlink()


def test_yaml_config_is_valid():
    """Test that YAML configuration files are valid"""
    try:
        import yaml
        
        current_file = Path(__file__)
        project_root = current_file.parent.parent.parent
        
        config_dir = project_root / '_config_template'
        user_config = config_dir / 'user_config.yml'
        
        if user_config.exists():
            with open(user_config, 'r') as f:
                config = yaml.safe_load(f)
            
            assert config is not None
            
    except ImportError:
        pytest.skip("yaml not installed")


def test_python_path_includes_project():
    """Test that Python can find modules in project"""
    # This is more of a sanity check
    assert sys.path is not None
    assert len(sys.path) > 0
