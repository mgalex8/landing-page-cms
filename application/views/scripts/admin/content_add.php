<h2><?php echo $result['title']; ?></h2>
<div class="span12" style="padding:40px">    
    <form action="<?php echo $result['action_url']; ?>" method="post" enctype="multypart/form-data">        
        <table>
            <tr>
                <td class="span2"></td>
                <td><div class="error errors">                        
                        <?php
                            foreach ($result['errors'] as $err)
                            {
                                echo '<div>' . $err . '</div>';
                            }    
                        ?>
                    </div></td>
            </tr>                    
            <tr>
                <td class="span2"><?php echo __('ID'); ?>*:</td>
                <td><input type="text" name="name" value="<?php echo $result['item']['name']; ?>" /></td>
            </tr>
            <tr>
                <td class="span2"><?php echo __('Name'); ?>*:</td>
                <td><input type="text" name="name" value="<?php echo $result['item']['name']; ?>" /></td>
            </tr>           
            <tr>
                <td class="span2"><?php echo __('Description'); ?>*:</td>
                <td><input type="text" name="text" value="<?php echo $result['item']['text']; ?>" /></td>                    
            </tr>
            <?php 
                foreach ($result['fields'] as $field): 
            ?>
                    <tr>
                    <td class="span2"><?php echo i18n($field['i18n'], $field['title']; ?><?php if ($field['required'] == 1): ?>*<?php endif; ?>:</td>
            <?php
            
                    // TEXT, FILE, HIDDEN
                    if ($field['type'] == 'text' || $field['type'] == 'file' || $field['type'] == 'hidden') :
                        $field_type = $field['type'];
                        if ($field['type'] == 'hidden')
                            $field_type = 'text';
                        if ($field['multiple']) :
            ?>  
                            <td id="field<?php $field['id']; ?>">
                                <div>
                                    <input type="<?php echo $field_type; ?>" name="field[<?php echo $field['name']; ?>][]" value="<?php echo $result['field_values'][$field['name']]; ?>" />
                                    <input type="<?php echo $field_type; ?>" name="field[<?php echo $field['name']; ?>][]" value="<?php echo $result['field_values'][$field['name']]; ?>" />
                                    <input type="<?php echo $field_type; ?>" name="field[<?php echo $field['name']; ?>][]" value="<?php echo $result['field_values'][$field['name']]; ?>" />
                                </div>
                                <div>
                                    <a class="btn btn-success" href="javascript:void()"><i class="icon-chevron-left icon-white"></i><?php echo __('Add'); ?></a>
                                </div>
                            </td>
            <?php       else : ?>
                            <td id="field<?php $field['id']; ?>"><input type="<?php echo $field_type; ?>" name="field[<?php echo $field['name']; ?>]" value="<?php echo $result['field_values'][$field['name']]; ?>" /></td>
            <?php 
                        endif;
                        
                    // CHECKBOX    
                    elseif ($field['type'] == 'checkbox') :
            ?>
                            <td id="field<?php $field['id']; ?>"><input type="chackbox" name="field[<?php echo $field['name']; ?>]"<?php if($result['field_values'][$field['name']] == 'on'): ?> checked<?php endif; ?> /></td>
            <?php 
            
                    // TEXTAREA
                    elseif ($field['type'] == 'textarea') :
            ?>
                            <td id="field<?php $field['id']; ?>"><textarea name="field[<?php echo $field['name']; ?>]"><?php echo $result['field_values'][$field['name']]; ?></textarea></td>
            <?php 
            
                    // SELECT
                    elseif ($field['type'] == 'select') :
            ?>
                            <td id="field<?php $field['id']; ?>"><select name="field[<?php echo $field['name']; ?>]"></select></td>
            <?php 
                    endif; 
            ?>
                    </tr>
            <?php
                endforeach; 
            ?>
            <tr>
                <td class="span2" colspan="2">&nbsp</td>
            </tr>
            <tr>
                <td class="span2"></td>
                <td><input type="submit" class="btn btn-success" value="<?php echo $result['title']; ?>" /></td>
            </tr>
        </table>          
    </form>
<div>