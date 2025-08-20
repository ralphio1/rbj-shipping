"""
Custom Integration Plugin Hooks
Demonstrates how to hook into Karrio events
"""

from karrio.core.events import on_event

@on_event('shipment.created')
def on_shipment_created(shipment):
    """Handle shipment creation events"""
    print(f"Custom plugin: Shipment {shipment.id} created")

@on_event('shipment.updated')
def on_shipment_updated(shipment):
    """Handle shipment update events"""
    print(f"Custom plugin: Shipment {shipment.id} updated")

@on_event('tracking.updated')
def on_tracking_updated(tracking):
    """Handle tracking update events"""
    print(f"Custom plugin: Tracking updated for {tracking.tracking_number}")
