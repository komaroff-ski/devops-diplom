
local app_name = 'nginx-app';
local prefix = 'stage';
local repl = 1;
[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: app_name + '-' +prefix,
      labels: {
        app: app_name + '-' +prefix,
      },
    },
    spec: {
      replicas: repl,
      selector: {
        matchLabels: {
          app: app_name + '-' +prefix,
        },
      },
      template: {
        metadata: {
          labels: {
            app: app_name + '-' +prefix,
          },
        },
        spec: {
          containers: [
            {
              name: app_name + '-' +prefix,
              image: 'docker.io/komaroffski/ng-app',
              imagePullPolicy: 'Always',
            },
          ],
        },
      },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: app_name + '-' +prefix,
      labels: {
        app: 'svc-' + app_name + '-' +prefix,
      }
    },
    spec: {
      type: 'NodePort',
      selector: {
        app: app_name + '-' +prefix,
      },
      ports: [
        {
          port: 80,
          name: 'http',
          nodePort: 30080,
        },
      ],
    },
  },
]
