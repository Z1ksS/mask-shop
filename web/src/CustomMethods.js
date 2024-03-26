function GetParentResourceName() { // default GetParentResourceName is not defined 
  return "mask-shop"
}

function InvokingNuiCallback(resource, information, cb) {
  if (!information) information = {};
  fetch(`https://${GetParentResourceName()}/${resource}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify(information)
  }).then(resp => resp.json()).then(data => {if (cb) cb(data);})
}

export {InvokingNuiCallback}