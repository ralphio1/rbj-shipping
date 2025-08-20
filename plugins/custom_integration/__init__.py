"""
Custom Integration Plugin for Karrio
This plugin demonstrates how to extend Karrio with custom functionality
"""

from karrio.core.plugins import Plugin

class CustomIntegration(Plugin):
    id = 'custom_integration'
    name = 'Custom Integration'
    version = '1.0.0'
    description = 'A sample custom integration plugin for Karrio'

    def initialize(self):
        """Initialize the plugin"""
        from . import hooks, services
        
        print(f"Custom Integration Plugin {self.version} initialized")

plugin = CustomIntegration()
