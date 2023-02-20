package stripedemo

class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(controller: "customer", action: "index")
        "/success"(controller: "customer", action: "index")
        "/fail"(view:"/fail")
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}
