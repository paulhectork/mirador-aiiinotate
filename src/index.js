import Mirador from 'mirador';
import Mae from "mirador-annotation-editor";

// TEST 1:
// import from root => undefined
import { LocalStorageAdapter } from "mirador-annotation-editor";
import { AiiinotateAdapter } from "mirador-annotation-editor";

// TEST 2:
// try to use the same path as in dev pre-packaging: not working either, logically
import { LocalStorageAdapter } from "mirador-annotation-editor/src/annotationAdapter/LocalStorageAdapter";
import { AiiinotateAdapter } from "mirador-annotation-editor/src/annotationAdapter/AiiinotateAdapter";

console.log("Mirador", Mirador);  // defined
console.log("Mae", Mae);  // defined
console.log("LocalStorageAdapter", LocalStorageAdapter);  // undefined
console.log("AiiinotateAdapter", AiiinotateAdapter);  // undefined

const iiifAnnotationVersion = 2;

const config = {
  id: 'miradorRoot',
  language: 'en',
  annotation: {
    adapter: (canvasId) => new AiiinotateAdapter(process.env.APP_BASE_URL, iiifAnnotationVersion, canvasId),
    allowTargetShapesStyling: true,
    commentTemplates: [{
      content: '<h4>Comment</h4><p>Comment content</p>',
      title: 'Template',
    },
    {
      content: '<h4>Comment2</h4><p>Comment content</p>',
      title: 'Template 2',
    }],
    debug: true,
    exportLocalStorageAnnotations: true,
    readonly: false,
    tagsSuggestions: ['Mirador', 'Awesome', 'Viewer', 'IIIF', 'Template'],
  },
  annotations: {
    htmlSanitizationRuleSet: 'liberal',
  },
  themes: {
    dark: {
      typography: {
        formSectionTitle: {
          color: '#5A8264',
          fontSize: '1rem',
          fontWeight: 600,
          letterSpacing: '0.1em',
          textTransform: 'uppercase',
        },
        subFormSectionTitle: {
          fontSize: '1.383rem',
          fontWeight: 300,
          letterSpacing: '0em',
          lineHeight: '1.33em',
          textTransform: 'uppercase',
        },
      },
    },
    light: {
      palette: {
        primary: {
          main: '#5A8264',
        },
      },
      typography: {
        formSectionTitle: {
          color: '#5A8264',
          fontSize: '1.215rem',
        },
        subFormSectionTitle: {
          fontSize: '0.937rem',
          fontWeight: 300,

        },
      },
    },
  },
  window: {
    defaultSideBarPanel: 'annotations',
    sideBarOpenByDefault: true,
  },
  windows: [
    { manifestId: ' https://iiif.harvardartmuseums.org/manifests/object/299843' },
  ],
};

Mirador.viewer(config)

