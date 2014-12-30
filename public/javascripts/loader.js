Ext.Loader.setConfig({
    enabled: true,
    disableCaching: false,
    paths: {
        GeoExt: "/javascripts/geoext2/src/GeoExt",
        Ext: "/extjs/src"
    }
});

Ext.require(['Ext.container.Viewport',
    'Ext.window.MessageBox',
    'GeoExt.panel.Map',
    'GeoExt.Action',
    'GeoExt.form.field.GeocoderComboBox',
    'Ext.XTemplate']);

