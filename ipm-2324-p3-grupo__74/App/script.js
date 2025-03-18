let taskCounter = 0;


window.onload = function () {
    closeModal();
    if (window.innerWidth >= 1200) {
        nuevaTarea();
    }
};

//estas dos funciones se hacen para poder cerrar el modal sin raton
document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') {
        closeModal();
    }
});

function closeModal() {
    var modal = document.getElementById('detailsModal');
    modal.style.display = 'none';
}


function nuevaTarea() {
    var tarea = document.getElementById("tarea");
    if (tarea.style.display === "none") {
        tarea.style.display = "block";
    } else {
        tarea.style.display = "none";
    }
}

function addNewlines(text, maxLength) {
    let result = '';
    for (let i = 0; i < text.length; i++) {
        result += text[i];
        if ((i + 1) % maxLength === 0) {
            result += '\n';
        }
    }
    return result;
}
function addNote() {
    // Se usa a la hora de eliminar (si está checked el counter no se le hace update)
    var checked = false;

    // Obtiene los valores del formulario
    const titleInput = addNewlines(document.getElementById('titleInput').value, 20);
    const shortDescriptionInput = addNewlines(document.getElementById('shortDescriptionInput').value, 20);
    const descriptionInput = addNewlines(document.getElementById('descriptionInput').value, 20);
    const deadlineInput = addNewlines(document.getElementById('deadlineInput').value, 20);

    if (titleInput.trim() !== '') {
        const noteList = document.getElementById('noteList');
        const li = document.createElement('li');
        const checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
	    checkbox.setAttribute('role', 'checkbox');//
	    checkbox.setAttribute('aria-checked', 'false');//
        checkbox.addEventListener('change', function() {
            updateTaskCounter(this.checked ? -1 : 1);
            // Si está completada pasa a no completada y viceversa
            checked = !checked;
	        this.setAttribute('aria-checked', this.checked.toString());//
        });

        // Crea el icono para editar (no tiene funcionalidad)
        const editButton = document.createElement('button');
        editButton.innerHTML = '\u{1F589}'; // Icono de lápiz
        editButton.className = 'edit-button';
	    editButton.setAttribute('role', 'button');//
        editButton.setAttribute('aria-label', 'Editar tarea');

        const deleteButton = document.createElement('button');
        deleteButton.className = 'delete-button';
	    deleteButton.setAttribute('role', 'button');
	    deleteButton.setAttribute('aria-label', 'Eliminar tarea');
        const deleteIcon = document.createTextNode('\u{1F5D1}');
        deleteButton.appendChild(deleteIcon);
        deleteButton.addEventListener('click', function() {
            li.remove();
            if (!checked) {
                // Si la tarea no está completada se actualiza el counter de tareas pendientes
                updateTaskCounter(-1);
            }
        });

        const detailsLink = document.createElement('a');
        detailsLink.href = '#'; // Enlace sin destino real por ahora
        detailsLink.textContent = titleInput;
        detailsLink.style.fontSize = '1.5em';
	    detailsLink.setAttribute('role', 'link');
	    detailsLink.setAttribute('aria-label', 'Detalles de la tarea');
        detailsLink.addEventListener('click', function() {
            // Lógica para mostrar los elementos previamente ingresados
            const detailsContainer = document.getElementById('detailsContainer');
            detailsContainer.innerHTML = `
                <h2>${titleInput}</h2>
                <h3>${shortDescriptionInput}</h3>
                <p>${descriptionInput}</p>
                <p>${deadlineInput}</p>
            `;
            // Muestra un modal o realiza otra acción según tu diseño
            // Abre el modal
            const modal = document.getElementById('detailsModal');
            modal.style.display = 'block';
        });
       
        const spaceSpan = document.createElement('span');
        spaceSpan.className = 'space';
        
        const description = document.createElement('div');
        description.className = 'details-container';
	    description.setAttribute('role', 'region');
	    description.setAttribute('aria-label', 'Descripción de la tarea');
        li.appendChild(checkbox);
        li.appendChild(spaceSpan);
        li.appendChild(detailsLink);
        if (window.innerWidth < 500) {
            description.innerHTML = `<span class="space"></span><p aria-live="polite">${deadlineInput}</p>`;
        } else {
            description.innerHTML = `<span class="space"></span><h3 aria-live="polite">${shortDescriptionInput}</h3><span class="space"></span><p aria-live="polite">${deadlineInput}</p>`;
        }

        li.appendChild(description);
        li.appendChild(spaceSpan);
        const buttonsContainer = document.createElement('div');
        buttonsContainer.className = 'buttons-container';
	    //buttonsContainer.setAttribute('role', 'group');
        buttonsContainer.appendChild(deleteButton);
        buttonsContainer.appendChild(spaceSpan);
        buttonsContainer.appendChild(editButton);
        li.appendChild(buttonsContainer);

        noteList.appendChild(li);

        updateTaskCounter(1);
        document.getElementById('noteForm').reset();

        // Verifica si estamos en escritorio antes de ocultar el elemento tarea
        if (window.innerWidth < 1200) {
            document.getElementById('tarea').style.display = 'none';
        }
    }
}



// Función para cerrar el modal
function closeModal() {
    const modal = document.getElementById('detailsModal');
    modal.style.display = 'none';
}


function updateTaskCounter(change) {
    taskCounter += change;
    document.getElementById('taskCounter').textContent = taskCounter;
}

function deleteAllNotes() {
    const noteList = document.getElementById('noteList');
    noteList.innerHTML = '';
    taskCounter = 0;
    document.getElementById('taskCounter').textContent = taskCounter;
}

function deleteCompletedNotes() {
    const completedNotes = document.querySelectorAll('#noteList li input[type="checkbox"]:checked');
    completedNotes.forEach(note => {
        note.parentElement.remove();
    });
}

function markAllAsCompleted() {
    const markAllCheckbox = document.getElementById('markAllCompleted');
    const checkboxes = document.querySelectorAll('#noteList li input[type="checkbox"]');
    
    checkboxes.forEach(checkbox => {
        if (checkbox.checked !== markAllCheckbox.checked) {
            checkbox.checked = markAllCheckbox.checked;
            // Actualiza el contador solo si hay un cambio en la marca del checkbox
            updateTaskCounter(markAllCheckbox.checked ? -1 : 1);
        }
    });
}



