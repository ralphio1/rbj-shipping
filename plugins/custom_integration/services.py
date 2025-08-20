"""
Custom Integration Plugin Services
Demonstrates how to add custom services to Karrio
"""

from karrio.core.models import Shipment
from karrio.core.utils import logger

class CustomService:
    """Custom service for the integration plugin"""
    
    @staticmethod
    def process_shipment(shipment: Shipment):
        """Process a shipment with custom logic"""
        logger.info(f"Custom service processing shipment {shipment.id}")
        
        # Add your custom logic here
        # For example: external API calls, data transformation, etc.
        
        return {
            'status': 'processed',
            'shipment_id': shipment.id,
            'custom_data': 'Your custom data here'
        }
    
    @staticmethod
    def validate_shipment(shipment: Shipment):
        """Validate a shipment with custom rules"""
        logger.info(f"Custom service validating shipment {shipment.id}")
        
        # Add your custom validation logic here
        validation_errors = []
        
        # Example validation
        if not shipment.recipient:
            validation_errors.append("Recipient information is required")
        
        return {
            'is_valid': len(validation_errors) == 0,
            'errors': validation_errors
        }
