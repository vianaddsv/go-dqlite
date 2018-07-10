#!/bin/bash

request_init() {
    cat > request.go <<EOF
package client

// DO NOT EDIT
//
// This file was generated by ./schema.sh

import (
	"github.com/CanonicalLtd/dqlite/internal/bindings"
)
EOF
}

response_init() {
    cat > response.go <<EOF
package client

// DO NOT EDIT
//
// This file was generated by ./schema.sh

import (
	"fmt"

	"github.com/CanonicalLtd/dqlite/internal/bindings"
)
EOF
}

entity=$1
shift

cmd=$1
shift

if [ "$entity" = "--request" ]; then
    if [ "$cmd" = "init" ]; then
	request_init
	exit
    fi

    args=""

    for i in "${@}"
    do
	name=$(echo "$i" | cut -f 1 -d :)
	type=$(echo "$i" | cut -f 2 -d :)

	if [ "$name" = "unused" ]; then
	    continue
	fi

	args=$(echo "${args}, ${name} ${type}")
    done

    cat >> request.go <<EOF

// Encode${cmd} encodes a $cmd request.
func Encode${cmd}(request *Message${args}) {
EOF

    for i in "${@}"
    do
	name=$(echo "$i" | cut -f 1 -d :)
	type=$(echo "$i" | cut -f 2 -d :)

	if [ "$name" = "unused" ]; then
	    name=$(echo "0")
	fi

	cat >> request.go <<EOF
	request.Put${type^}(${name})
EOF
    done

    cat >> request.go <<EOF

	request.PutHeader(bindings.Request${cmd})
}
EOF

fi

if [ "$entity" = "--response" ]; then
    if [ "$cmd" = "init" ]; then
	response_init
	exit
    fi

    returns=""

    for i in "${@}"
    do
	name=$(echo "$i" | cut -f 1 -d :)
	type=$(echo "$i" | cut -f 2 -d :)

	if [ "$name" = "unused" ]; then
	    continue
	fi

	returns=$(echo "${returns}${name} ${type}, ")
    done

    cat >> response.go <<EOF

// Decode${cmd} decodes a $cmd response.
func Decode${cmd}(response *Message) (${returns}err error) {
	mtype, _ := response.GetHeader()

	if mtype == bindings.ResponseFailure {
		e := ErrRequest{}
		e.Code = response.GetUint64()
		e.Description = response.GetString()
                err = e
                return
	}

	if mtype == bindings.ResponseDbError {
		e := ErrDb{}
		e.Code = response.GetUint64()
		e.ExtendedCode = response.GetUint64()
		e.Description = response.GetString()
                err = e
                return
	}

	if mtype != bindings.Response${cmd} {
		err = fmt.Errorf("unexpected response type %d", mtype)
                return
	}

EOF

    for i in "${@}"
    do
	name=$(echo "$i" | cut -f 1 -d :)
	type=$(echo "$i" | cut -f 2 -d :)

	assign=$(echo "${name} = ")

	if [ "$name" = "unused" ]; then
	    assign=$(echo "")
	fi

	cat >> response.go <<EOF
	${assign}response.Get${type^}()
EOF
    done

    cat >> response.go <<EOF

	return
}
EOF

fi
