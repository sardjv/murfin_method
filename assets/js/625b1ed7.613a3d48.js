(window.webpackJsonp=window.webpackJsonp||[]).push([[13],{81:function(e,t,n){"use strict";n.r(t),n.d(t,"frontMatter",(function(){return a})),n.d(t,"metadata",(function(){return c})),n.d(t,"toc",(function(){return s})),n.d(t,"default",(function(){return p}));var r=n(3),i=n(7),o=(n(0),n(93)),a={id:"authentication",title:"Authentication"},c={unversionedId:"authentication",id:"authentication",isDocsHomePage:!1,title:"Authentication",description:"Devise",source:"@site/docs/authentication.md",sourceDirName:".",slug:"/authentication",permalink:"/murfin_plus/docs/authentication",editUrl:"https://github.com/sardjv/murfin_method/edit/master/docs/docs/authentication.md",version:"current",frontMatter:{id:"authentication",title:"Authentication"},sidebar:"someSidebar",previous:{title:"Technical Overview",permalink:"/murfin_plus/docs/overview"},next:{title:"Requirements",permalink:"/murfin_plus/docs/requirements"}},s=[{value:"Devise",id:"devise",children:[]},{value:"API Tokens",id:"api-tokens",children:[]}],u={toc:s};function p(e){var t=e.components,n=Object(i.a)(e,["components"]);return Object(o.b)("wrapper",Object(r.a)({},u,n,{components:t,mdxType:"MDXLayout"}),Object(o.b)("h2",{id:"devise"},"Devise"),Object(o.b)("p",null,"The ",Object(o.b)("a",{parentName:"p",href:"https://github.com/heartcombo/devise"},"Devise gem")," is used to handle administrator authentication. The first ESR Wrapper administrator must be bootstrapped by the developer performing the installation. All subsequent administrators can be activated by administrators who have already been activated."),Object(o.b)("h2",{id:"api-tokens"},"API Tokens"),Object(o.b)("p",null,"Administrators can generate bearer tokens which can be used to access the API. The token must be passed in request headers in the format ",Object(o.b)("inlineCode",{parentName:"p"},"Authorization: Bearer <token>"),". The API checks if the token exists, and then checks if the token has permission to access the requested resource. It filters the returned columns according to the permissions granted to the token by the administrator."))}p.isMDXComponent=!0},93:function(e,t,n){"use strict";n.d(t,"a",(function(){return l})),n.d(t,"b",(function(){return f}));var r=n(0),i=n.n(r);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function a(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function c(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?a(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):a(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function s(e,t){if(null==e)return{};var n,r,i=function(e,t){if(null==e)return{};var n,r,i={},o=Object.keys(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||(i[n]=e[n]);return i}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(i[n]=e[n])}return i}var u=i.a.createContext({}),p=function(e){var t=i.a.useContext(u),n=t;return e&&(n="function"==typeof e?e(t):c(c({},t),e)),n},l=function(e){var t=p(e.components);return i.a.createElement(u.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return i.a.createElement(i.a.Fragment,{},t)}},m=i.a.forwardRef((function(e,t){var n=e.components,r=e.mdxType,o=e.originalType,a=e.parentName,u=s(e,["components","mdxType","originalType","parentName"]),l=p(n),m=r,f=l["".concat(a,".").concat(m)]||l[m]||d[m]||o;return n?i.a.createElement(f,c(c({ref:t},u),{},{components:n})):i.a.createElement(f,c({ref:t},u))}));function f(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var o=n.length,a=new Array(o);a[0]=m;var c={};for(var s in t)hasOwnProperty.call(t,s)&&(c[s]=t[s]);c.originalType=e,c.mdxType="string"==typeof e?e:r,a[1]=c;for(var u=2;u<o;u++)a[u]=n[u];return i.a.createElement.apply(null,a)}return i.a.createElement.apply(null,n)}m.displayName="MDXCreateElement"}}]);